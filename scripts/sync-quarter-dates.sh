#!/usr/bin/env bash
# Sincroniza os campos Start e End nos Projects v2 com base no campo
# "Sprint/Trimestre" (formato YYYY-Qn) dos 8 projects próprios.
#
# Uso: PROJECTS_TOKEN=<token> [ORGANIZATION=ArthemizLabs] bash sync-quarter-dates.sh
#
# Para cada item dos projects próprios que tiver Sprint/Trimestre definido e
# Start/End divergentes do trimestre calculado, o script atualiza:
#   - o próprio project onde o campo foi definido
#   - o Master (#16)
#   - o Roadmap (#23)
# Se o item não existir em Master/Roadmap, apenas loga e continua.
# O script é idempotente: não reescreve campos já corretos.

set -euo pipefail

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

# ─── Helper: chamar a API GraphQL ─────────────────────────────────────────────
graphql() {
  local payload="$1"
  curl -sS \
    -H "Authorization: Bearer ${PROJECTS_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -d "$payload" \
    https://api.github.com/graphql
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

# ─── Query: dados completos de um project (campos + itens com fieldValues) ────
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
          content {
            __typename
            ... on Issue { id }
            ... on PullRequest { id }
          }
          fieldValues(first: 20) {
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

# ─── Query: dados de um project sem fieldValues (usado para Master/Roadmap) ───
readonly QUERY_PROJETO_ITENS='query($org: String!, $number: Int!, $cursor: String) {
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
# Logs de progresso: stderr
buscar_dados_projeto() {
  local numero_projeto="$1"
  local query="$2"

  local payload resposta project_id project_title fields_json todos_itens
  local has_next_page end_cursor itens_nova_pagina

  # Primeira página (sem cursor)
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

  # Páginas adicionais
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
# Entrada: JSON do project (de buscar_dados_projeto) e nome do campo
# Saída  : ID do campo ou string vazia
obter_field_id() {
  local dados_projeto="$1"
  local nome_campo="$2"
  echo "$dados_projeto" | jq -r \
    --arg name "$nome_campo" '.fields[] | select(.name == $name) | .id' | head -n 1
}

# ─── Atualizar campo de data em um project ────────────────────────────────────
# Retorna 0 em caso de sucesso, 1 em caso de erro.
atualizar_data_campo() {
  local project_id="$1"
  local item_id="$2"
  local field_id="$3"
  local date_value="$4"
  local nome_campo="$5"  # apenas para log

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

dados_master=$(buscar_dados_projeto "$NUMERO_MASTER" "$QUERY_PROJETO_ITENS")
dados_roadmap=$(buscar_dados_projeto "$NUMERO_ROADMAP" "$QUERY_PROJETO_ITENS")

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

# ─── Loop principal: varrer os 8 projects próprios ────────────────────────────
total_sincronizados=0
total_ignorados=0

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

  # Obter field IDs do project próprio
  field_start_proprio=$(obter_field_id "$dados_projeto" "$CAMPO_START")
  field_end_proprio=$(obter_field_id "$dados_projeto" "$CAMPO_END")
  field_trimestre_proprio=$(obter_field_id "$dados_projeto" "$CAMPO_TRIMESTRE")

  if [ -z "$field_start_proprio" ] || [ -z "$field_end_proprio" ] || [ -z "$field_trimestre_proprio" ]; then
    echo "  AVISO: Campos Start, End ou Sprint/Trimestre não encontrados neste project. Ignorando."
    continue
  fi

  numero_itens=$(echo "$dados_projeto" | jq '.items | length')
  echo "  ${numero_itens} item(s) encontrado(s)."

  for i in $(seq 0 $((numero_itens - 1))); do
    item=$(echo "$dados_projeto" | jq ".items[$i]")
    item_id_proprio=$(echo "$item" | jq -r '.id')
    content_id=$(echo "$item" | jq -r '.content.id // empty')

    # Pular itens sem conteúdo (drafts, etc.)
    if [ -z "$content_id" ]; then
      continue
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

    # Verificar valores atuais para idempotência
    current_start=$(echo "$item" | jq -r \
      --arg name "$CAMPO_START" \
      '.fieldValues.nodes[] | select(.field.name == $name) | .date // empty' | head -n 1)
    current_end=$(echo "$item" | jq -r \
      --arg name "$CAMPO_END" \
      '.fieldValues.nodes[] | select(.field.name == $name) | .date // empty' | head -n 1)

    if [ "${current_start:-}" = "$expected_start" ] && [ "${current_end:-}" = "$expected_end" ]; then
      echo "  Item ${content_id}: já sincronizado (${trimestre_valor} → Start=${expected_start}, End=${expected_end}). Ignorando."
      total_ignorados=$((total_ignorados + 1))
      continue
    fi

    echo "  Item ${content_id}: Sprint/Trimestre=${trimestre_valor}"
    echo "    Atual:    Start='${current_start:-vazio}', End='${current_end:-vazio}'"
    echo "    Esperado: Start='${expected_start}', End='${expected_end}'"

    # 1) Atualizar no project próprio
    echo "    Atualizando ${titulo_projeto} (#${numero_projeto})..."
    atualizar_data_campo "$id_projeto" "$item_id_proprio" "$field_start_proprio" "$expected_start" "$CAMPO_START"
    atualizar_data_campo "$id_projeto" "$item_id_proprio" "$field_end_proprio" "$expected_end" "$CAMPO_END"
    echo "    OK: ${titulo_projeto}."

    # 2) Atualizar no Master
    item_id_master=$(echo "$dados_master" | jq -r \
      --arg contentId "$content_id" \
      '.items[] | select(.content != null and .content.id == $contentId) | .id' | head -n 1)

    if [ -z "$item_id_master" ]; then
      echo "    INFO: Item não encontrado no Master (#${NUMERO_MASTER}). Ignorando."
    elif [ -z "$field_start_master" ] || [ -z "$field_end_master" ]; then
      echo "    AVISO: Campos Start/End não encontrados no Master. Ignorando."
    else
      atualizar_data_campo "$id_master" "$item_id_master" "$field_start_master" "$expected_start" "$CAMPO_START"
      atualizar_data_campo "$id_master" "$item_id_master" "$field_end_master" "$expected_end" "$CAMPO_END"
      echo "    OK: ${titulo_master}."
    fi

    # 3) Atualizar no Roadmap
    item_id_roadmap=$(echo "$dados_roadmap" | jq -r \
      --arg contentId "$content_id" \
      '.items[] | select(.content != null and .content.id == $contentId) | .id' | head -n 1)

    if [ -z "$item_id_roadmap" ]; then
      echo "    INFO: Item não encontrado no Roadmap (#${NUMERO_ROADMAP}). Ignorando."
    elif [ -z "$field_start_roadmap" ] || [ -z "$field_end_roadmap" ]; then
      echo "    AVISO: Campos Start/End não encontrados no Roadmap. Ignorando."
    else
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
echo "  Itens sincronizados nesta execução : ${total_sincronizados}"
echo "  Itens já corretos (ignorados)      : ${total_ignorados}"
