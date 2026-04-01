# Sincronização automática de datas: Sprint/Trimestre → Start/End

## O que o workflow faz

O workflow `sync-quarter-dates` varre automaticamente os **8 projects próprios** da organização `ArthemizLabs` e, para cada item que tiver o campo **Sprint/Trimestre** preenchido, calcula as datas de início e fim do trimestre e as sincroniza nos campos **Start** e **End** de três projects:

1. O **project próprio** onde o campo foi definido
2. O **Master** (Project #16)
3. O **Roadmap** (Project #23)

O script é **idempotente** em todos os destinos: antes de executar cada mutation, verifica se os valores de **Start** e **End** já coincidem com os calculados — tanto no project próprio quanto no **Master** (#16) e no **Roadmap** (#23). Mutations desnecessárias são puladas.

### Exemplo

| Sprint/Trimestre | Start      | End        |
|------------------|------------|------------|
| `2026-Q1`        | 2026-01-01 | 2026-03-31 |
| `2026-Q2`        | 2026-04-01 | 2026-06-30 |
| `2026-Q3`        | 2026-07-01 | 2026-09-30 |
| `2026-Q4`        | 2026-10-01 | 2026-12-31 |

---

## Trigger

O workflow é acionado:

- **Automaticamente** a cada 15 minutos (`schedule: cron: "*/15 * * * *"`)  
  Somente itens atualizados nos últimos 20 minutos são processados (modo incremental).
- **Manualmente** via interface do GitHub Actions (`workflow_dispatch`)  
  Aceita o parâmetro `full_scan` (`true`/`false`). Com `full_scan=true`, todos os itens são varridos independentemente da data de atualização (útil para reconciliação completa).

---

## Projects monitorados

| Project          | Número |
|------------------|--------|
| Languages        | #30    |
| Certifications   | #31    |
| Open Source      | #26    |
| Vendas3D         | #19    |
| Arthemiz         | #29    |
| Sentinel Agent   | #25    |
| OpsLedger        | #28    |
| System Health    | #27    |
| **Master**       | #16    |
| **Roadmap**      | #23    |

> Master e Roadmap são apenas destinos: não são varridos como fonte, mas têm Start/End atualizados quando o item existir neles.

---

## Pré-requisitos: configurar `PROJECTS_TOKEN`

### 1. Criar o token

1. Acesse **GitHub → Configurações → Developer settings → Personal access tokens → Tokens (classic)**
2. Clique em **Generate new token (classic)**
3. Defina uma data de validade adequada
4. Selecione os escopos:
   - `read:org`
   - `project` (necessário para ler e escrever em Projects v2)
5. Clique em **Generate token** e copie o valor gerado

### 2. Adicionar como secret no repositório

1. Acesse o repositório `ArthemizLabs/.github`
2. Vá em **Settings → Secrets and variables → Actions**
3. Clique em **New repository secret**
4. Preencha:
   - **Name**: `PROJECTS_TOKEN`
   - **Secret**: o token gerado no passo anterior
5. Clique em **Add secret**

### 3. Validar o token

Execute o workflow `validate-tokens` (já existente no repositório) para confirmar que o token consegue **ler** os Projects v2. Para validar **escrita**, utilize o workflow `validar-tokens-escrita`.

---

## Como debugar via logs

1. Acesse **Actions → sync-quarter-dates** no repositório
2. Clique na execução desejada
3. Expanda o step **Sincronizar Sprint/Trimestre → Start/End nos Projects v2**

### Mensagens esperadas

| Mensagem                                              | Significado                                                    |
|-------------------------------------------------------|----------------------------------------------------------------|
| `Item <id>: já sincronizado em todos os destinos (...). Ignorando.` | Start/End corretos nos 3 destinos; nenhuma mutation executada |
| `Item <id>: Sprint/Trimestre=2026-Q3 → Start=..., End=...` | Item será sincronizado em um ou mais destinos            |
| `OK: <NomeProjeto>.`                                  | Start/End atualizados com sucesso naquele project              |
| `INFO: Item não encontrado no Master (#16). Ignorando.` | Item não está adicionado ao Master; não é um erro             |
| `INFO: Item não encontrado no Roadmap (#23). Ignorando.` | Item não está adicionado ao Roadmap; não é um erro           |
| `AVISO: Campos Start, End ou Sprint/Trimestre não encontrados neste project. Ignorando.` | Project não tem os campos esperados |
| `ERRO: Chamada GraphQL falhou com status HTTP <N>.`   | Falha na API (401 = token inválido, 403 = sem permissão)       |
| `ERRO: Variável de ambiente PROJECTS_TOKEN não está configurada.` | Secret não configurado; veja a seção de pré-requisitos |

### Contadores ao final da execução

```
Sincronização concluída.
  Itens sincronizados nesta execução : 3
  Itens já corretos (ignorados)      : 12
```

---

## Arquivos relacionados

| Arquivo                                        | Descrição                                      |
|------------------------------------------------|------------------------------------------------|
| `.github/workflows/sync-quarter-dates.yml`     | Workflow que aciona o script                   |
| `scripts/sync-quarter-dates.sh`                | Script principal de sincronização (bash + jq)  |
