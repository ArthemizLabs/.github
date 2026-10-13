<div align="center">

<img src="https://raw.githubusercontent.com/ArthemizLabs/.github/main/site/assets/favicon.png" width="96" alt="ArthemizLabs" />

# ArthemizLabs

**Software que roda em produção, construído com método.**<br/>
Backend · Dados · Cloud · Segurança

[![Site](https://img.shields.io/badge/site-site.arthemiz.com.br-4f8cff?style=for-the-badge&logo=googlechrome&logoColor=white)](https://site.arthemiz.com.br)
[![Portfólio](https://img.shields.io/badge/portf%C3%B3lio-Arthur%20Borges-22d3ee?style=for-the-badge&logo=github&logoColor=white)](https://portfolio.arthemiz.com.br)

<sub>🇧🇷 Português · <a href="#-english">🇺🇸 English below</a> · Atualizado em 13/10/2026</sub>

</div>

---

A **ArthemizLabs** é a organização onde [Arthur Mamedes Borges](https://github.com/A4thu4) constrói e opera seus sistemas: aplicações reais usadas pelo setor público e por clientes, e projetos de estudo para aprofundar arquitetura, segurança e cloud.

## 🟢 Em produção e em uso

| Projeto | O que faz | Stack | Status |
| --- | --- | --- | --- |
| **[Simulador PROMOVE](https://simulador-promove.arthemiz.com.br)** | Simula a evolução funcional de servidores públicos de Goiás, com análise em lote e leitura de processos do SEI via LLM | FastAPI · PostgreSQL · Next.js · Docker · AWS | 🟢 Produção |
| **[cobranca-app](https://cobranca-app.arthemiz.com.br)** | SaaS multi-tenant de cobrança via WhatsApp com CRM e white-label por domínio | FastAPI · PostgreSQL · React · Nginx · Oracle Cloud | 🟢 Produção |
| **Portal Serviços Goiás** | App desktop com serviços plugáveis que automatizam rotinas no SEI | Python · Selenium · PyInstaller | 🟢 Em uso |
| **Comparador SEAD** | Compara textos, PDFs e planilhas e exporta o diff | Java 21 · Spring Boot · Thymeleaf | 🟢 Em uso |
| **[BiblioSystem](https://github.com/ArthemizLabs/biblio-system)** | Gestão de biblioteca (projeto da faculdade) | Java · Swing · MySQL | ✅ Público |
| **[Jornada Dev](https://github.com/ArthemizLabs/jornada-dev)** | Plataforma de estudos gamificada com 20 trilhas | React · TypeScript · Tailwind | ✅ Público |

> Código privado na maioria dos casos (cliente ou setor público). A arquitetura real está em [site.arthemiz.com.br/architecture](https://site.arthemiz.com.br/architecture.html).

## 🧪 Projetos de estudo (futuros)

Projetos que existem para aprender algo específico. Ainda não estão em produção e entram no [roadmap](https://site.arthemiz.com.br/roadmap.html) no ano em que fazem sentido.

| Projeto | Ideia | Para aprender | Previsão |
| --- | --- | --- | --- |
| **OpsLedger** | Livro-razão de operações com trilha de auditoria | Modelagem transacional, RabbitMQ, Redis | 2027 |
| **Sentinel Agent** | Agente leve em C que coleta métricas do host | C de sistemas, Linux, segurança de baixo nível | 2028 |
| **SystemHealth** | Painel de saúde dos containers da própria org | Prometheus, Grafana, alertas | 2028 |
| **Vendas3D** | Loja com produtos visualizados em 3D | Modelagem 3D, renderização web, Kubernetes | 2029 |

## Como trabalhamos

- **Segurança desde o início:** JWT com RBAC, segredos só por variável de ambiente, auditoria de segurança antes de cada PR.
- **Ambientes reproduzíveis:** Docker Compose e Dev Containers do desenvolvimento à produção.
- **Decisões registradas:** toda decisão técnica relevante tem contexto, alternativas e reversibilidade documentados.
- **Histórico legível:** Conventional Commits, branches descritivas e PRs com resumo, impacto de segurança e testes.
- **Simples antes de distribuído:** monólito bem dividido primeiro, microsserviços só com motivo medido.

## Stack

[![Stack](https://skillicons.dev/icons?i=python,fastapi,java,spring,postgres,mysql,docker,nginx,aws,azure,cloudflare,githubactions,react,nextjs,ts,tailwind&perline=9)](https://skillicons.dev)

---

<details>
<summary><b>🇺🇸 English</b></summary>

<a id="-english"></a>

**ArthemizLabs** is the organization where [Arthur Mamedes Borges](https://github.com/A4thu4) builds and runs his systems: real applications used by the public sector and by clients, plus study projects to go deeper into architecture, security and cloud.

### In production and in use

| Project | What it does | Stack | Status |
| --- | --- | --- | --- |
| **[PROMOVE Simulator](https://simulador-promove.arthemiz.com.br)** | Simulates career progression for Goiás state public servants, with batch analysis and LLM-based reading of case files | FastAPI · PostgreSQL · Next.js · Docker · AWS | 🟢 Production |
| **[cobranca-app](https://cobranca-app.arthemiz.com.br)** | Multi-tenant SaaS for collections over WhatsApp with CRM and domain-based white-label | FastAPI · PostgreSQL · React · Nginx · Oracle Cloud | 🟢 Production |
| **Portal Serviços Goiás** | Desktop app with pluggable services that automate routines in SEI (government case system) | Python · Selenium · PyInstaller | 🟢 In use |
| **SEAD Comparator** | Compares text, PDFs and spreadsheets and exports the diff | Java 21 · Spring Boot · Thymeleaf | 🟢 In use |
| **[BiblioSystem](https://github.com/ArthemizLabs/biblio-system)** | Library management (university project) | Java · Swing · MySQL | ✅ Public |
| **[Jornada Dev](https://github.com/ArthemizLabs/jornada-dev)** | Gamified learning platform with 20 tracks | React · TypeScript · Tailwind | ✅ Public |

### Study projects (future)

| Project | Idea | To learn | Target |
| --- | --- | --- | --- |
| **OpsLedger** | Operations ledger with an audit trail | Transactional modeling, RabbitMQ, Redis | 2027 |
| **Sentinel Agent** | Lightweight C agent for host metrics | Systems C, Linux, low-level security | 2028 |
| **SystemHealth** | Health dashboard for the org's own containers | Prometheus, Grafana, alerting | 2028 |
| **Vendas3D** | Storefront with 3D product views | 3D modeling, web rendering, Kubernetes | 2029 |

These are not in production yet. They are planned learning projects, listed openly as such.

</details>
