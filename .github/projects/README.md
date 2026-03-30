# GitHub Projects — IMIGRATION_2030

Documentação dos GitHub Projects v2 configurados para o roadmap **IMIGRATION_2030** da organização [ArthemizLabs](https://github.com/ArthemizLabs).

---

## Visão Geral

O roadmap IMIGRATION_2030 é estruturado em **5 projetos GitHub** que cobrem todas as dimensões necessárias para atingir o objetivo de imigração como Engenheiro Pleno/Sênior com diploma, inglês C1, japonês N2 e portfólio de alta qualificação.

| Projeto | Tipo | Repositórios | Descrição |
|---|---|---|---|
| [Master Roadmap](#-master-roadmap) | Tabela | — | Visão macro de carreira — todas as fases e epics |
| [OpsLedger & Sentinel Agent](#-opsledger--system-health) | Board (Kanban) | `ops-ledger`, `sentinel-agent` | Backend Java/Spring Boot + monitoramento Docker |
| [Vendas3D](#-vendas3d) | Board (Kanban) | `shop-ecommerce` | E-commerce Python/FastAPI |
| [Arthemiz & SystemHealth](#-arthemiz--sentinel-agent) | Board (Kanban) | `system-health` | Infra Go + agente de telemetria em C |
| [Global Resume](#-global-resume) | Lista | — | Contribuições Open Source para o portfólio |

---

## Como Criar os Projetos

### Pré-requisitos

1. **Token com permissões de projeto:** Crie um Personal Access Token (PAT) com os escopos `project` e `read:org`.
2. **Adicione como secret da organização:** `Settings → Secrets and variables → Actions → New organization secret` com o nome `PROJECTS_TOKEN`.

### Executar o Workflow

```bash
# Via GitHub CLI
gh workflow run setup-imigration-projects.yml \
  -f dry_run=false \
  -f project=all

# Criar apenas um projeto específico
gh workflow run setup-imigration-projects.yml \
  -f dry_run=false \
  -f project=master-roadmap
```

Ou acesse: `Actions → Setup IMIGRATION_2030 GitHub Projects → Run workflow`.

> **Dica:** Execute com `dry_run=true` primeiro para validar sem criar nada.

---

## Master Roadmap 2030

**Tipo:** Tabela | **Layout:** `TABLE_LAYOUT`

Visão macro centralizada de todo o roadmap. Cada item representa uma tarefa ou marco que contribui para os três pilares de imigração.

### Campos Personalizados

| Campo | Tipo | Opções |
|---|---|---|
| **Fase** | Select | `PHASE_2026` · `PHASE_2027` · `PHASE_2028` · `PHASE_2029` |
| **País Alvo** | Select | `Japão 🇯🇵` · `Canadá 🇨🇦` · `Global` |
| **Tipo** | Select | `Certificação` · `Idioma` · `Acadêmico` · `Tech` |
| **Épico** | Select | `TECH_STACK` · `PORTFOLIO` · `LANG_EN` · `LANG_JP` · `CERTIFICATIONS` |
| **Pilar de Imigração** | Select | `Diploma` · `Idioma C1/N2` · `Portfólio` · `Certificação` |
| **DoD** | Texto | Definition of Done — critérios objetivos de conclusão |

### Views

| View | Layout | Agrupamento/Filtro |
|---|---|---|
| Backlog Completo | Tabela | Todas as tarefas |
| Timeline por Fase | Roadmap/Timeline | Agrupado por **Fase** |
| Priority — Certificações & Idiomas | Tabela | Filtrado: `Tipo = Certificação` ou `Tipo = Idioma` |
| Kanban por Status | Board | Agrupado por Status |
| Por Épico | Tabela | Agrupado por **Épico** |

### Config

Arquivo: [`.github/projects/configs/master-roadmap.json`](./configs/master-roadmap.json)

---

## OpsLedger & Sentinel Agent

**Tipo:** Board (Kanban) | **Repositórios:** `OpsLedger`, `sentinel-agent`

Gerencia o desenvolvimento do backend financeiro em Java/Spring Boot e do agente de telemetria em C.

### Workflow de Desenvolvimento (Padrão Sênior)

```
Backlog → Ready to Dev → In Progress → In Review → Done
```

| Coluna | Critério de Entrada |
|---|---|
| **Backlog** | Ideia ou requisito bruto adicionado ao projeto |
| **Ready to Dev** | Issue tem DoD definido, está estimada e desbloqueada |
| **In Progress** | Branch criada, desenvolvimento iniciado |
| **In Review** | Pull Request aberto, aguardando aprovação |
| **Done** | PR aprovado, merged e deployed no ambiente correspondente |

### Campos Personalizados

| Campo | Tipo | Opções |
|---|---|---|
| **Status** | Select | `Backlog` · `Ready to Dev` · `In Progress` · `In Review` · `Done` |
| **Fase** | Select | `PHASE_2026` · `PHASE_2027` · `PHASE_2028` · `PHASE_2029` |
| **Componente** | Select | `OpsLedger` · `Sentinel Agent` · `Shared` |
| **DoD** | Texto | Definition of Done |
| **Estimativa (h)** | Número | Horas estimadas |
| **PR Link** | Texto | URL do Pull Request |

### Views

| View | Layout | Descrição |
|---|---|---|
| Board Principal | Board | Kanban por Status — execução diária |
| Por Fase | Tabela | Agrupado por fase do roadmap |
| Por Componente | Tabela | Separação entre OpsLedger e Sentinel Agent |

### Config

Arquivo: [`.github/projects/configs/ops-ledger-sentinel.json`](./configs/ops-ledger-sentinel.json)

---

## Vendas3D

**Tipo:** Board (Kanban) | **Repositório:** `Vendas3D`

Gerencia o e-commerce de produtos 3D — catálogo, fila de produção, inventário, pagamentos e API pública.

### Workflow de Desenvolvimento (Padrão Sênior)

```
Backlog → Ready to Dev → In Progress → In Review → Done
```

### Campos Personalizados

| Campo | Tipo | Opções |
|---|---|---|
| **Status** | Select | `Backlog` · `Ready to Dev` · `In Progress` · `In Review` · `Done` |
| **Fase** | Select | `PHASE_2026` · `PHASE_2027` · `PHASE_2028` · `PHASE_2029` |
| **Módulo** | Select | `Catálogo` · `Produção` · `Inventário` · `Pagamentos` · `Segurança` · `API Pública` · `Infra/DevOps` |
| **DoD** | Texto | Definition of Done |
| **Estimativa (h)** | Número | Horas estimadas |
| **PR Link** | Texto | URL do Pull Request |

### Views

| View | Layout | Descrição |
|---|---|---|
| Board Principal | Board | Kanban por Status — execução diária |
| Por Fase | Tabela | Agrupado por fase do roadmap |
| Por Módulo | Tabela | Separado por módulo do sistema |

### Config

Arquivo: [`.github/projects/configs/vendas3d.json`](./configs/vendas3d.json)

---

## Arthemiz & SystemHealth

**Tipo:** Board (Kanban) | **Repositórios:** `Arthemiz`, `SystemHealth`

Gerencia a infraestrutura de rede em Go (DNS, proxy, TLS) e o sistema de observabilidade (Docker, Prometheus, Grafana).

### Workflow de Desenvolvimento (Padrão Sênior)

```
Backlog → Ready to Dev → In Progress → In Review → Done
```

### Campos Personalizados

| Campo | Tipo | Opções |
|---|---|---|
| **Status** | Select | `Backlog` · `Ready to Dev` · `In Progress` · `In Review` · `Done` |
| **Fase** | Select | `PHASE_2026` · `PHASE_2027` · `PHASE_2028` · `PHASE_2029` |
| **Sistema** | Select | `Arthemiz` · `SystemHealth` · `Shared` |
| **Camada** | Select | `Network` · `Auth` · `Observability` · `Container` · `Security` · `Infra/DevOps` |
| **DoD** | Texto | Definition of Done |
| **Estimativa (h)** | Número | Horas estimadas |
| **PR Link** | Texto | URL do Pull Request |

### Views

| View | Layout | Descrição |
|---|---|---|
| Board Principal | Board | Kanban por Status — execução diária |
| Por Fase | Tabela | Agrupado por fase do roadmap |
| Por Sistema | Tabela | Separação entre Arthemiz e SystemHealth |
| Segurança & Infra | Tabela | Filtrado para camadas Security, Network e Container |

### Config

Arquivo: [`.github/projects/configs/arthemiz-systemhealth.json`](./configs/arthemiz-systemhealth.json)

---

## The Global Resume

**Tipo:** Lista | **Layout:** `TABLE_LAYOUT`

Monitora contribuições Open Source como pilar do portfólio de alta qualificação para o visto de "High Skilled Professional".

### Por que é importante para o visto?

- Demonstra **nível de inglês técnico** (comunicação em PRs internacionais)
- Comprova **experiência prática** em projetos reais de grande porte
- Adiciona **pontos** no sistema de pontos (HSP Japão / Express Entry Canadá)

### Campos Personalizados

| Campo | Tipo | Opções |
|---|---|---|
| **Status da Contribuição** | Select | `Hunting` · `Draft` · `In Review` · `Merged` · `Rejected` · `Abandoned` |
| **Link do PR** | Texto | URL do Pull Request no repositório upstream |
| **Repositório Pai** | Texto | Ex: `nestjs/nest`, `hashicorp/terraform` |
| **Fase** | Select | `PHASE_2026` · `PHASE_2027` · `PHASE_2028` · `PHASE_2029` |
| **Tipo de Contribuição** | Select | `Bug Fix` · `Feature` · `Docs` · `Refactor` · `Test` · `Chore` |
| **Impacto no Visto** | Select | `Alto` · `Médio` · `Baixo` |
| **Stars do Repositório** | Número | Popularidade do projeto upstream |
| **Observações** | Texto | Feedback dos maintainers, lições aprendidas |

### Views

| View | Layout | Descrição |
|---|---|---|
| Todas as Contribuições | Tabela | Lista completa |
| Merged — Portfólio Público | Tabela | Apenas contribuições aceitas — portfólio para o visto |
| Board de Acompanhamento | Board | Kanban por Status da Contribuição |
| Por Fase | Tabela | Agrupado por fase do roadmap |

### Config

Arquivo: [`.github/projects/configs/global-resume.json`](./configs/global-resume.json)

---

## Templates

Os templates abaixo servem como base para montar ou atualizar arquivos de configuração de projetos:

| Template | Uso |
|---|---|
| [`technical-board-template.json`](./templates/technical-board-template.json) | Boards Kanban para projetos técnicos — inclui workflow padrão sênior e campos de DoD/PR Link |
| [`project-template.json`](./templates/project-template.json) | Template genérico para qualquer tipo de projeto — suporta Table, Board e Roadmap |

**Limitação atual do workflow**

O workflow `setup-imigration-projects.yml` **não lê automaticamente** todos os arquivos em `.github/projects/configs/`.  
Neste momento, ele cria apenas os **5 projetos pré-configurados** descritos na seção de visão geral (Master Roadmap, OpsLedger & Sentinel Agent, Vendas3D, Arthemiz & SystemHealth e The Global Resume).
A lógica de criação desses projetos está atualmente **hardcoded no YAML do workflow**; os arquivos em `.github/projects/configs/` servem como referência/documentação e não são carregados nem aplicados automaticamente pelo workflow.

Isso significa que:

- Copiar um template para `.github/projects/configs/<nome-do-projeto>.json` **não fará com que um novo projeto seja criado automaticamente**.
- O comando abaixo, com `project=all`, **apenas (re)cria os 5 projetos existentes**, mesmo que haja outros arquivos em `configs/`:

  
---

## Pilares de Imigração

Todo item movido para **Done** em qualquer projeto deve contribuir para ao menos um dos três pilares:

```
Diploma          — Graduação em Ciência da Computação
Idioma C1/N2     — Inglês C1 (IELTS 7.0+) e Japonês N2 (JLPT)
Portfólio        — SaaS em produção + Open Source + Certificações
```

---

## Estrutura de Arquivos

```
.github/projects/
├── README.md                              # Esta documentação
├── configs/
│   ├── master-roadmap.json                # Master Roadmap 2030
│   ├── ops-ledger-sentinel.json           # OpsLedger & Sentinel Agent
│   ├── vendas3d.json                      # Vendas3D
│   ├── arthemiz-systemhealth.json         # Arthemiz & SystemHealth
│   └── global-resume.json                 # The Global Resume
└── templates/
    ├── technical-board-template.json      # Template para boards técnicos
    └── project-template.json              # Template genérico
```

---

*ArthemizLabs — Engineering-driven SaaS.*
