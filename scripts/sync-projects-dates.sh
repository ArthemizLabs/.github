#!/usr/bin/env bash
# Sincroniza os campos Start e End nos Projects v2 com base no campo
# "Sprint/Trimestre" (formato YYYY-Qn) dos 8 projects próprios.
#
# Uso: PROJECTS_TOKEN=<token> [ORGANIZATION=ArthemizLabs] [FULL_SCAN=false] [DEBUG=false] bash sync-projects-dates.sh
#
# Para cada item dos projects próprios que tiver Sprint/Trimestre definido e
# Start/End divergentes do trimestre calculado, o script atualiza:
#   - o próprio project onde o campo foi definido (apenas quando há divergência)
#   - o Master (#16)
#   - o Roadmap (#23)
# Se o item não existir em Master/Roadmap, apenas loga e continua.
# A verificação de idempotência (não reescrever campos já corretos) é feita
# em todos os três projects: o script pula mutations quando os valores
# calculados já coincidem com os atuais.

set -euo pipefail

DEBUG="${DEBUG:-false}"

# ─── Validação do token ───────────────────────────────────────────────────────
if [ -z "${PROJECTS_TOKEN:-}" ]; then
  echo "ERRO: Variável de ambiente PROJECTS_TOKEN não está configurada."
  echo "Configure o secret PROJECTS_TOKEN nas Actions Secrets do repositório."
  exit 1
fi

# ─── Configuração ─────────────────────────────────────────────────────────────
ORGANIZATION="${ORGANIZATION:-ArthemizLabs}"
readonly CAMPO_START="Start"
readonly CAMPO_END="End"
readonly CAMPO_TRIMESTRE="Sprint/Trimestre"
readonly NUMERO_MASTER=16
readonly NUMERO_ROADMAP=23
# 8 projects próprios: Languages, Certifications, Open Source, Vendas3D,
#                      Arthemiz, Sentinel Agent, OpsLedger, System Health
readonly PROJECTS_PROPRIOS=(30 31 26 19 29 25 28 27)

# Quando FULL_SCAN=true, processa todos os itens independentemente de updatedAt.
# Quando false (padrão), só processa itens atualizados nos últimos JANELA_MINUTOS.
FULL_SCAN="${FULL_SCAN:-false}"
JANELA_MINUTOS="${JANELA_MINUTOS:-20}"

# ─── Helper: chamar a API GraphQL ─────────────────────────────────────────────
graphql() {
  local payload="$1"
  local response status body

  # Captura corpo e status HTTP. O status é emitido como última linha via -w.
  response="$(curl -sS \
    -H "Authorization: Bearer ${PROJECTS_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -d "$payload" \
    -w $'\n%{http_code}' \
    https://api.github.com/graphql)"

  # Separa última linha (status) do restante (corpo JSON).
  status="${response##*$'\n'}"
  body="${response%$'\n'"$status"}"

  if [[ ! "$status" =~ ^2[0-9][0-9]$ ]]; then
    {
      echo "ERRO: Chamada GraphQL falhou com status HTTP ${status}."

      # Evita despejar o body completo por padrão (pode conter detalhes demais).
      if command -v jq >/dev/null 2>&1; then
        echo "Resumo do erro (campo .errors, se existir):"
        echo "$body" | jq -c '.errors // empty' || true
      else
        echo "Instale 'jq' para visualizar o resumo do erro."
      fi

      if [ "$DEBUG" = "true" ]; then
        echo "DEBUG=true: Corpo completo da resposta:"
        echo "$body"
      fi
    } >&2
    exit 1
  fi

  printf '%s\n' "$body"
}

# ─── Calcular datas do trimestre ──────────────────────────────────────────────
# Entrada : "YYYY-Qn"
# Saída   : "YYYY-MM-DD|YYYY-MM-DD"  (start|end)  ou string vazia se inválido
calcular_datas_trimestre() {
  local trimestre="$1"
  if ! echo "$trimestre" | grep -Eq '^[0-9]{4}-Q[1-4]$'; then
    echo ""
    return
  fi
  local ano quarter start end
  ano="${trimestre%-Q*}"
  quarter="${trimestre#*-Q}"
  case "$quarter" in
    1) start="${ano}-01-01"; end="${ano}-03-31" ;;
    2) start="${ano}-04-01"; end="${ano}-06-30" ;;
    3) start="${ano}-07-01"; end="${ano}-09-30" ;;
    4) start="${ano}-10-01"; end="${ano}-12-31" ;;
  esac
  echo "${start}|${end}"
}

# ─── Query: dados completos de um project próprio (campos + itens + fieldValues)
readonly QUERY_PROJETO_COMPLETO='query($org: String!, $number: Int!, $cursor: String) {
  organization(login: $org) {
    projectV2(number: $number) {
      id
      title
      fields(first: 100) {
        nodes {
          __typename
          ... on ProjectV2Field { id name dataType }
          ... on ProjectV2SingleSelectField { id name options { id name } }
          ... on ProjectV2IterationField { id name }
        }
      }
      items(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          updatedAt
          content {
            __typename
            ... on Issue { id }
            ... on PullRequest { id }
          }
          fieldValues(first: 50) {
            # 50 cobre todos os campos típicos de um project próprio (Status, Sprint,
            # Start, End, Priority, Labels, etc.). Ajuste se houver mais de 50 campos.
            nodes {
              __typename
              ... on ProjectV2ItemFieldDateValue {
                date
                field { ... on ProjectV2FieldCommon { name } }
              }
              ... on ProjectV2ItemFieldSingleSelectValue {
                name
                field { ... on ProjectV2FieldCommon { name } }
              }
            }
          }
        }
      }
    }
  }
}'

# ─── Query: dados dos projects destino (Master/Roadmap) com datas Start/End ───
readonly QUERY_PROJETO_DESTINO='query($org: String!, $number: Int!, $cursor: String) {
  organization(login: $org) {
    projectV2(number: $number) {
      id
      title
      fields(first: 100) {
        nodes {
          __typename
          ... on ProjectV2Field { id name dataType }
          ... on ProjectV2SingleSelectField { id name }
          ... on ProjectV2IterationField { id name }
        }
      }
      items(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          content {
            __typename
            ... on Issue { id }
            ... on PullRequest { id }
          }
          fieldValues(first: 10) {
            nodes {
              __typename
              ... on ProjectV2ItemFieldDateValue {
                date
                field { ... on ProjectV2FieldCommon { name } }
              }
            }
          }
        }
      }
    }
  }
}'

# ─── Mutation: atualizar campo de data ────────────────────────────────────────
readonly MUTATION_ATUALIZAR_DATA='mutation($projectId: ID!, $itemId: ID!, $fieldId: ID!, $date: Date!) {
  updateProjectV2ItemFieldValue(
    input: {
      projectId: $projectId
      itemId: $itemId
      fieldId: $fieldId
      value: { date: $date }
    }
  ) { projectV2Item { id } }
}'

# ─── Buscar todos os dados de um project (com paginação) ──────────────────────
# Saída stdout: JSON { id, title, fields, items }
buscar_dados_projeto() {
  local numero_projeto="$1"
  local query="$2"

  local payload resposta project_id project_title fields_json todos_itens
  local has_next_page end_cursor itens_nova_pagina

  payload=$(jq -n \
    --arg q "$query" \
    --arg org "$ORGANIZATION" \
    --argjson number "$numero_projeto" \
    '{query: $q, variables: {org: $org, number: $number, cursor: null}}')

  resposta=$(graphql "$payload")

  project_id=$(echo "$resposta" | jq -r '.data.organization.projectV2.id // empty')
  if [ -z "$project_id" ]; then
    echo "ERRO: Não foi possível obter dados do Project #${numero_projeto}." >&2
    echo "$resposta" | jq '.errors // .' >&2
    return 1
  fi

  project_title=$(echo "$resposta" | jq -r '.data.organization.projectV2.title')
  fields_json=$(echo "$resposta" | jq '.data.organization.projectV2.fields.nodes')
  todos_itens=$(echo "$resposta" | jq '.data.organization.projectV2.items.nodes')
  has_next_page=$(echo "$resposta" | jq -r '.data.organization.projectV2.items.pageInfo.hasNextPage')
  end_cursor=$(echo "$resposta" | jq -r '.data.organization.projectV2.items.pageInfo.endCursor // empty')

  while [ "$has_next_page" = "true" ] && [ -n "$end_cursor" ]; do
    payload=$(jq -n \
      --arg q "$query" \
      --arg org "$ORGANIZATION" \
      --argjson number "$numero_projeto" \
      --arg cursor "$end_cursor" \
      '{query: $q, variables: {org: $org, number: $number, cursor: $cursor}}')

    resposta=$(graphql "$payload")

    itens_nova_pagina=$(echo "$resposta" | jq '.data.organization.projectV2.items.nodes')
    todos_itens=$(jq -n \
      --argjson acc "$todos_itens" \
      --argjson nova "$itens_nova_pagina" \
      '$acc + $nova')

    has_next_page=$(echo "$resposta" | jq -r '.data.organization.projectV2.items.pageInfo.hasNextPage')
    end_cursor=$(echo "$resposta" | jq -r '.data.organization.projectV2.items.pageInfo.endCursor // empty')
  done

  jq -n \
    --arg id "$project_id" \
    --arg title "$project_title" \
    --argjson fields "$fields_json" \
    --argjson items "$todos_itens" \
    '{id: $id, title: $title, fields: $fields, items: $items}'
}

# ─── Obter ID de um campo por nome a partir dos dados do project ──────────────
obter_field_id() {
  local dados_projeto="$1"
  local nome_campo="$2"
  echo "$dados_projeto" | jq -r \
    --arg name "$nome_campo" '.fields[] | select(.name == $name) | .id' | head -n 1
}

# ─── Atualizar campo de data em um project ────────────────────────────────────
atualizar_data_campo() {
  local project_id="$1"
  local item_id="$2"
  local field_id="$3"
  local date_value="$4"
  local nome_campo="$5"

  local payload resposta erros
  payload=$(jq -n \
    --arg q "$MUTATION_ATUALIZAR_DATA" \
    --arg projectId "$project_id" \
    --arg itemId "$item_id" \
    --arg fieldId "$field_id" \
    --arg date "$date_value" \
    '{query: $q, variables: {projectId: $projectId, itemId: $itemId, fieldId: $fieldId, date: $date}}')

  resposta=$(graphql "$payload")
  erros=$(echo "$resposta" | jq '.errors | length // 0')

  if [ "$erros" -gt 0 ]; then
    echo "    ERRO ao atualizar campo '${nome_campo}':" >&2
    echo "$resposta" | jq '.errors' >&2
    return 1
  fi
}

# ─── Carregar dados de Master e Roadmap ───────────────────────────────────────
echo "Carregando dados do Master (#${NUMERO_MASTER}) e Roadmap (#${NUMERO_ROADMAP})..."

dados_master=$(buscar_dados_projeto "$NUMERO_MASTER" "$QUERY_PROJETO_DESTINO")
dados_roadmap=$(buscar_dados_projeto "$NUMERO_ROADMAP" "$QUERY_PROJETO_DESTINO")

id_master=$(echo "$dados_master" | jq -r '.id')
titulo_master=$(echo "$dados_master" | jq -r '.title')
id_roadmap=$(echo "$dados_roadmap" | jq -r '.id')
titulo_roadmap=$(echo "$dados_roadmap" | jq -r '.title')

field_start_master=$(obter_field_id "$dados_master" "$CAMPO_START")
field_end_master=$(obter_field_id "$dados_master" "$CAMPO_END")

field_start_roadmap=$(obter_field_id "$dados_roadmap" "$CAMPO_START")
field_end_roadmap=$(obter_field_id "$dados_roadmap" "$CAMPO_END")

echo "  ${titulo_master}: Start fieldId=${field_start_master:-<não encontrado>}, End fieldId=${field_end_master:-<não encontrado>}"
echo "  ${titulo_roadmap}: Start fieldId=${field_start_roadmap:-<não encontrado>}, End fieldId=${field_end_roadmap:-<não encontrado>}"

# ─── Construir tabelas de lookup para Master e Roadmap ────────────────────────
# Permite acesso em O(1) por content_id dentro do loop de itens.
declare -A mapa_item_master mapa_start_master mapa_end_master
declare -A mapa_item_roadmap mapa_start_roadmap mapa_end_roadmap

while IFS='|' read -r content_id item_id start_val end_val; do
  [ -n "$content_id" ] || continue
  mapa_item_master["$content_id"]="$item_id"
  mapa_start_master["$content_id"]="$start_val"
  mapa_end_master["$content_id"]="$end_val"
done < <(echo "$dados_master" | jq -r \
  --arg start_field "$CAMPO_START" \
  --arg end_field "$CAMPO_END" \
  '.items[] | select(.content != null) |
   .content.id as $cid | .id as $iid |
   ((.fieldValues.nodes // [] | map(select(.field.name == $start_field)) | .[0].date) // "") as $s |
   ((.fieldValues.nodes // [] | map(select(.field.name == $end_field)) | .[0].date) // "") as $e |
   [$cid, $iid, $s, $e] | join("|")')

while IFS='|' read -r content_id item_id start_val end_val; do
  [ -n "$content_id" ] || continue
  mapa_item_roadmap["$content_id"]="$item_id"
  mapa_start_roadmap["$content_id"]="$start_val"
  mapa_end_roadmap["$content_id"]="$end_val"
done < <(echo "$dados_roadmap" | jq -r \
  --arg start_field "$CAMPO_START" \
  --arg end_field "$CAMPO_END" \
  '.items[] | select(.content != null) |
   .content.id as $cid | .id as $iid |
   ((.fieldValues.nodes // [] | map(select(.field.name == $start_field)) | .[0].date) // "") as $s |
   ((.fieldValues.nodes // [] | map(select(.field.name == $end_field)) | .[0].date) // "") as $e |
   [$cid, $iid, $s, $e] | join("|")')

echo "  Master:  ${#mapa_item_master[@]} item(s) indexado(s)."
echo "  Roadmap: ${#mapa_item_roadmap[@]} item(s) indexado(s)."

# ─── Calcular cutoff para filtro por updatedAt ────────────────────────────────
# Nota: date -u -d é sintaxe GNU coreutils (disponível em ubuntu-latest do GitHub Actions).
cutoff_ts=0
if [ "$FULL_SCAN" != "true" ]; then
  cutoff_ts=$(date -u -d "${JANELA_MINUTOS} minutes ago" +%s)
  echo ""
  echo "Modo incremental: processando apenas itens atualizados nos últimos ${JANELA_MINUTOS} minutos."
  echo "Para varrer todos os itens, defina FULL_SCAN=true."
else
  echo ""
  echo "Modo FULL_SCAN: processando todos os itens independentemente de data de atualização."
fi

total_sincronizados=0
total_ignorados=0
total_fora_da_janela=0

echo ""
echo "=============================="
echo "Varrendo ${#PROJECTS_PROPRIOS[@]} projects próprios..."

for numero_projeto in "${PROJECTS_PROPRIOS[@]}"; do
  echo ""
  echo "── Project #${numero_projeto} ──"

  dados_projeto=$(buscar_dados_projeto "$numero_projeto" "$QUERY_PROJETO_COMPLETO")
  id_projeto=$(echo "$dados_projeto" | jq -r '.id')
  titulo_projeto=$(echo "$dados_projeto" | jq -r '.title')
  echo "  ${titulo_projeto} (${id_projeto})"

  field_start_proprio=$(obter_field_id "$dados_projeto" "$CAMPO_START")
  field_end_proprio=$(obter_field_id "$dados_projeto" "$CAMPO_END")
  field_trimestre_proprio=$(obter_field_id "$dados_projeto" "$CAMPO_TRIMESTRE")

  if [ -z "$field_start_proprio" ] || [ -z "$field_end_proprio" ] || [ -z "$field_trimestre_proprio" ]; then
    echo "  AVISO: Campos Start, End ou Sprint/Trimestre não encontrados neste project. Ignorando."
    continue
  fi

  numero_itens=$(echo "$dados_projeto" | jq '.items | length')
  echo "  ${numero_itens} item(s) encontrado(s)."

  if [ "$numero_itens" -eq 0 ]; then
    continue
  fi
  for i in $(seq 0 $((numero_itens - 1))); do
    item=$(echo "$dados_projeto" | jq ".items[$i]")
    item_id_proprio=$(echo "$item" | jq -r '.id')
    content_id=$(echo "$item" | jq -r '.content.id // empty')

    # Pular itens sem conteúdo (drafts, etc.)
    if [ -z "$content_id" ]; then
      continue
    fi

    # Filtrar por janela de atualização quando não é FULL_SCAN
    if [ "$FULL_SCAN" != "true" ]; then
      updated_at=$(echo "$item" | jq -r '.updatedAt // empty')
      if [ -n "$updated_at" ]; then
        updated_ts=$(date -u -d "$updated_at" +%s 2>/dev/null || echo "0")
        if [ "$updated_ts" -lt "$cutoff_ts" ]; then
          total_fora_da_janela=$((total_fora_da_janela + 1))
          continue
        fi
      fi
    fi

    # Obter valor do campo Sprint/Trimestre
    trimestre_valor=$(echo "$item" | jq -r \
      --arg name "$CAMPO_TRIMESTRE" \
      '.fieldValues.nodes[] | select(.field.name == $name) | .name // empty' | head -n 1)

    if [ -z "$trimestre_valor" ]; then
      continue
    fi

    # Calcular datas esperadas
    datas=$(calcular_datas_trimestre "$trimestre_valor")
    if [ -z "$datas" ]; then
      echo "  Item ${content_id}: Sprint/Trimestre='${trimestre_valor}' é inválido (esperado YYYY-Qn). Ignorando."
      continue
    fi

    expected_start="${datas%|*}"
    expected_end="${datas#*|}"

    # Verificar idempotência no project próprio
    current_start=$(echo "$item" | jq -r \
      --arg name "$CAMPO_START" \
      '.fieldValues.nodes[] | select(.field.name == $name) | .date // empty' | head -n 1)
    current_end=$(echo "$item" | jq -r \
      --arg name "$CAMPO_END" \
      '.fieldValues.nodes[] | select(.field.name == $name) | .date // empty' | head -n 1)

    necessita_proprio=false
    if [ "${current_start:-}" != "$expected_start" ] || [ "${current_end:-}" != "$expected_end" ]; then
      necessita_proprio=true
    fi

    # Verificar idempotência no Master via lookup table
    item_id_master="${mapa_item_master[$content_id]:-}"
    necessita_master=false
    if [ -n "$item_id_master" ] && [ -n "$field_start_master" ] && [ -n "$field_end_master" ]; then
      start_master="${mapa_start_master[$content_id]:-}"
      end_master="${mapa_end_master[$content_id]:-}"
      if [ "$start_master" != "$expected_start" ] || [ "$end_master" != "$expected_end" ]; then
        necessita_master=true
      fi
    fi

    # Verificar idempotência no Roadmap via lookup table
    item_id_roadmap="${mapa_item_roadmap[$content_id]:-}"
    necessita_roadmap=false
    if [ -n "$item_id_roadmap" ] && [ -n "$field_start_roadmap" ] && [ -n "$field_end_roadmap" ]; then
      start_roadmap="${mapa_start_roadmap[$content_id]:-}"
      end_roadmap="${mapa_end_roadmap[$content_id]:-}"
      if [ "$start_roadmap" != "$expected_start" ] || [ "$end_roadmap" != "$expected_end" ]; then
        necessita_roadmap=true
      fi
    fi

    # Se não há nada a atualizar em nenhum dos destinos, ignorar
    if [ "$necessita_proprio" = "false" ] && [ "$necessita_master" = "false" ] && [ "$necessita_roadmap" = "false" ]; then
      echo "  Item ${content_id}: já sincronizado em todos os destinos (${trimestre_valor} → Start=${expected_start}, End=${expected_end}). Ignorando."
      total_ignorados=$((total_ignorados + 1))
      continue
    fi

    echo "  Item ${content_id}: Sprint/Trimestre=${trimestre_valor} → Start=${expected_start}, End=${expected_end}"

    # 1) Atualizar no project próprio se necessário
    if [ "$necessita_proprio" = "true" ]; then
      echo "    Atualizando ${titulo_projeto} (#${numero_projeto})..."
      atualizar_data_campo "$id_projeto" "$item_id_proprio" "$field_start_proprio" "$expected_start" "$CAMPO_START"
      atualizar_data_campo "$id_projeto" "$item_id_proprio" "$field_end_proprio" "$expected_end" "$CAMPO_END"
      echo "    OK: ${titulo_projeto}."
    fi

    # 2) Atualizar no Master se necessário
    if [ -z "$item_id_master" ]; then
      echo "    INFO: Item não encontrado no Master (#${NUMERO_MASTER}). Ignorando."
    elif [ -z "$field_start_master" ] || [ -z "$field_end_master" ]; then
      echo "    AVISO: Campos Start/End não encontrados no Master. Ignorando."
    elif [ "$necessita_master" = "true" ]; then
      echo "    Atualizando ${titulo_master} (#${NUMERO_MASTER})..."
      atualizar_data_campo "$id_master" "$item_id_master" "$field_start_master" "$expected_start" "$CAMPO_START"
      atualizar_data_campo "$id_master" "$item_id_master" "$field_end_master" "$expected_end" "$CAMPO_END"
      echo "    OK: ${titulo_master}."
    fi

    # 3) Atualizar no Roadmap se necessário
    if [ -z "$item_id_roadmap" ]; then
      echo "    INFO: Item não encontrado no Roadmap (#${NUMERO_ROADMAP}). Ignorando."
    elif [ -z "$field_start_roadmap" ] || [ -z "$field_end_roadmap" ]; then
      echo "    AVISO: Campos Start/End não encontrados no Roadmap. Ignorando."
    elif [ "$necessita_roadmap" = "true" ]; then
      echo "    Atualizando ${titulo_roadmap} (#${NUMERO_ROADMAP})..."
      atualizar_data_campo "$id_roadmap" "$item_id_roadmap" "$field_start_roadmap" "$expected_start" "$CAMPO_START"
      atualizar_data_campo "$id_roadmap" "$item_id_roadmap" "$field_end_roadmap" "$expected_end" "$CAMPO_END"
      echo "    OK: ${titulo_roadmap}."
    fi

    total_sincronizados=$((total_sincronizados + 1))
  done
done

echo ""
echo "=============================="
echo "Sincronização concluída."
echo "  Itens sincronizados nesta execução  : ${total_sincronizados}"
echo "  Itens já corretos (ignorados)       : ${total_ignorados}"
if [ "$FULL_SCAN" != "true" ]; then
  echo "  Itens fora da janela de ${JANELA_MINUTOS} min (ignorados): ${total_fora_da_janela}"
fi
