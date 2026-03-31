# 🚀 IMIGRATION_2030 — Documentação do Projeto

## Visão Geral

**Projeto:** `IMIGRATION_2030`

**Objetivo Macro:** Chegar em 2030 como **Engenheiro de Software Pleno/Sênior**, com diploma, inglês fluente (C1) e japonês de negócios (N2), pronto para visto de "High Skilled Professional".

**Duração:** 4 Fases Anuais (2026-2029)

**Metodologia:** Planejamento de longo prazo com fases anuais e projetos.

## 🧰 Ferramentas e Tecnologias

*️⃣ -> **EM ESTUDO**

**Frontend:**

- Fundamentos Web (HTML/CSS/JS) *️⃣
- React/Angular + TypeScript
- Next.js 15+ (App Router & Server Actions) — SSR, Auth, SEO
- TailwindCSS

---

**Backend & Enterprise:**

- Java (Spring Boot) *️⃣
- Python (FastAPI) — ingestão, ETL e workers *️⃣
- C# (.NET) — leitura e interoperabilidade enterprise
- Node.js (NestJS) — APIs modulares

---

**Bancos de Dados:**

- PostgreSQL (principal) *️⃣
- Oracle Database (PL/SQL, modelagem corporativa) — "Performance Tuning" ou "Partitioning" *️⃣
- Redis (cache)

---

**DevOps, Cloud & Infra:**

- Versionamento (Git/GitHub) *️⃣
- Linux (admin intermediário)
- Docker & Docker Compose & Kubernetes
- Nginx — reverse proxy
- GitHub Actions — CI/CD *️⃣
- Terraform (básico) — Infra as Code
- AWS — EC2, VPC, IAM, S3
- Cloudflare — DNS, segurança, edge
- Prometheus / Grafana (conceitos)
- Logs estruturados (ELK / OpenSearch — conceitual)

---

**Mensageria & Dados:**

- RabbitMQ — filas e processamento assíncrono
- ETL com Python — Pandas / Polars
- Planejamento de rotas url como /Modo1 e /Modo2

## 🗓 Estrutura de Fases

Em vez de sprints curtas, trabalhar com **4 Fases Anuais** (quebrando em sprints trimestrais no dia a dia):

### PHASE_2026 — Foundation

**Foco:** Base técnica sólida + primeiros sistemas reais. Inglês Intermediário-Forte (B2).

**Objetivos:**

- Deploy Frontend via Vercel
- Deploy Backend via Railway
- Dominar linguagem tipada (Java)
- SQL avançado
- API's REST profissionais
- Cybersegurança (Fundamentos)
- Inglês técnico B2
- Alfabetos japoneses (Hiragana/Katakana)

**Certificação:**

- Oracle Database SQL (1Z0-071):
- AWS Certified Cloud Practitioner
- Oracle Certified Associate (Java)
- CertiProf Scrum Foundation

**Entregáveis:**

- OpsLedger — MVP monólito funcional
- Arthemiz — MVP de DNS
- E-commerce 3D — catálogo + fila simples
- Primeiras contribuições Open Source

---

### PHASE_2027 — Expansion

**Foco:** Cloud, Dados (ETL), complexidade real e Japonês (N5/N4).

**Objetivos:**

- Docker & Containerization
- Certificação e deploy Cloud (AWS/Azure/IaaS)
- Pipeline ETL & Filas e ingestão de dados (RabbitMQ + Python)
- RBAC e auditoria
- Inglês conversacional C1
- Genki I (N5)

**Certificação:**

- Oracle Certified Professional – Java SE 11/17 Developer
- Cloud Solutions (AWS Solutions Architect Associate/Azure Fundamentals DP-900)
- HashiCorp Terraform Associate

**Entregáveis:**

- SystemHealth com ingestão e cloud
- Arthemiz com RBAC e auditoria
- E-commerce com lógica de negócio completa
- Pull Requests relevantes em Open Source

---

### PHASE_2028 — Quality & Security

**Foco:** Segurança (AppSec), Qualidade, segurança e padrão profissional.

**Objetivos:**

- Provisionamento de VPS (Linux)
- Configuração manual de Nginx
- Configuração de proxy reverso para backend
- AppSec & OWASP Top 10
- CI/CD Pipelines com GitHub Actions
- Hardening de segurança
- JLPT N4

**Certificação:**

- VMware Certified Spring Professional
- CompTIA Security+
- IELTS oficial

**Entregáveis:**

- SystemHealth com pipelines e segurança
- Arthemiz hardenizado
- E-commerce com pagamentos internacionais

---

### PHASE_2029 — Mastery

**Foco:** Arquitetura de Sistemas, TCC complexo, Japonês Intermediário (N3/N2) e Certificações Finais.

**Objetivos:**

- System Design avançado
- Refatoração para microserviços
- Infra como código madura
- JLPT N3/N2

**Certificação:**

- Certificações finais
- FE (prova nacional de TI do Japão)

**Entregáveis:**

- SystemHealth em microserviços
- Arthemiz multi-tenant
- Portfólio estável e documentado

## Projetos

### Dominio Arthemiz — Infraestrutura e Segurança de Rede

**Objetivo:**
Controlar tráfego, segurança e roteamento dos serviços desenvolvidos. Gerir domínios, DNS e segurança de resolução voltado para ambientes críticos.

**Proposta de Valor:**
Centralizar controle de acesso e proteção dos outros sistemas.

**Stack:**

- Linguagem: Go
- Infra: Linux
- Funções: Reverse Proxy, Rate Limiting, TLS

**Conceitos Demonstrados:**

- Conceitos de rede
- TLS
- Firewall
- Proxy reverso
- Balanceamento de carga

**Modelo de Receita:**

- Projeto interno de infraestrutura.

**Roadmap:**

- 2027 — Reverse proxy básico
- 2028 — TLS customizado
- 2029 — Balanceamento e segurança avançada

---

### OpsLedger — B2B System Monitoring SaaS (Projeto Principal)

**Objetivo:**
Plataforma SaaS para monitoramento de servidores *Linux* e aplicações, processos e integridade operacional. Com visualização *Dashboard* de métricas em tempo real, alertas e histórico.

**Proposta de Valor:**
Permitir que pequenas e médias empresas monitorem infraestrutura sem depender de soluções enterprise complexas como *Datadog* ou *New Relic*.

**Stack:**

- Backend: Java + Spring Boot + JPA/Hibernate + JWT & RBAC
- Frontend: React + TypeScript
- Banco: OracleSQL
- Comunicação: REST + WebSockets
- Infra: Docker + Docker Compose + CI/CD
- Cloud futura: AWS

**Conceitos Demonstrados:**

- Arquitetura em Camadas (evoluindo para Hexagonal)
- API REST estruturada
- Autenticação JWT + Controle de acesso RBAC
- Persistência com JPA
- WebSockets para métricas em tempo real
- Logs estruturados
- Observabilidade básica (Prometheus futuramente)
- CI/CD + Containerização

**Modelo de Receita:**

- Plano Free (1 servidor)
- Plano Pro (até 5 servidores)
- Plano Enterprise (métricas avançadas + SLA)

**Roadmap:**

- 2026 — MVP funcional (coleta + dashboard básico)
- 2027 — Autenticação robusta + alertas
- 2028 — Hardening de segurança + logs estruturados
- 2029 — Escalabilidade + Cloud real

---

### Vendas3D — E-commerce Enterprise

**Objetivo:**
Loja online rópria para venda de serviços e produtos e serviços de impressão 3D, com personalização de atributos técnicos e automação de orçamento.

**Proposta de Valor:**
Sistema flexível para cadastro de produtos e com controle de pedidos com múltiplos parâmetros técnicos (material, volume, tempo estimado, acabamento) e geração automatizada de orçamento.

**Stack:**

- Backend: Python + FastAPI
- Banco: PostgreSQL (uso de JSONB)
- Autenticação: JWT
- Infra: Docker
- Pagamento: Integração futura (Stripe/Mercado Pago)

**Conceitos Demonstrados:**

- Modelagem relacional + JSON híbrido
- Sistema de pedidos
- Controle de estoque
- APIs REST bem estruturadas
- Processamento assíncrono (Celery futuro)
- Validação de dados (Pydantic)

**Modelo de Receita:**

- Venda real de serviços + uso como portfólio vivo.
- Upsell para serviços personalizados
- Sistema pode evoluir para white-label

**Roadmap:**

- 2026 — Sistema de produtos e pedidos + Integração com Pagamento + Banco modelado corretamente
- 2027 — Sistema de cálculo dinâmico de orçamento + Autenticação e painel admin
- 2028 — Hardening de segurança + logs estruturados
- 2029 — Escalabilidade + API pública para parceiros

---

### SystemHealth — Extensão Técnica do OpsLedger

**Objetivo:**
Especializar o monitoramento para ambientes Linux e containers Docker, explorando métricas mais profundas de sistema.

**Proposta de Valor:**
Ferramenta complementar focada em ambientes DevOps e infraestrutura containerizada.

**Stack:**

- Backend: Node.js (NestJS) ou extensão em Java
- Integração: Docker API
- Banco: PostgreSQL

**Conceitos Demonstrados:**

- Integração com Docker Engine
- Leitura de métricas de container
- Monitoramento de processos
- Estrutura modular
- Arquitetura orientada a eventos

**Modelo de Receita:**

- Add-on premium do OpsLedger
- Funcionalidade Enterprise

**Roadmap:**

- 2027 — Leitura de containers ativos
- 2028 — Métricas por container
- 2029 — Monitoramento distribuído

---

### Sentinel Agent — Telemetria em Baixo Nível (Projeto Avançado)

**Objetivo:**
Desenvolver um agente em C responsável por coletar métricas de sistema (CPU, memória, processos, disco) e enviá-las para o OpsLedger.

**Proposta de Valor:**
Permitir coleta leve e performática de métricas com baixo overhead, demonstrando domínio de sistemas operacionais.

**Stack:**

- Linguagem: C
- Sistema: Linux (POSIX)
- Comunicação: Sockets TCP/UDP
- Serialização: JSON ou binário leve

**Conceitos Demonstrados:**

- Sockets
- Threads
- Gestão de memória
- Chamadas de sistema
- Manipulação de arquivos
- Performance
- Estrutura modular em C

**Modelo de Receita:**

- Componente interno do OpsLedger.

**Roadmap:**

- 2027 — Coleta local de métricas
- 2028 — Comunicação via socket
- 2029 — Otimização e segurança

---

### Open Source Contribution

**Objetivo:**
Contribuir para projetos Open Source relevantes (segurança, cloud ou backend), demonstrando capacidade de trabalhar em código legado, seguir padrões internacionais e colaborar em times distribuídos.

**Proposta de Valor:**
Construir reputação técnica pública, fortalecer networking global e validar competências em ambientes reais de produção.

**Stack Envolvida:**
Depende do projeto escolhido, mas obrigatoriamente:

- Git avançado
- Code review
- Issue tracking
- Testes automatizados
- CI/CD real
- Documentação técnica em inglês

**Conceitos Demonstrados:**

- Leitura de código complexo
- Refatoração segura
- Escrita de testes
- Comunicação técnica em inglês
- Respeito a guidelines
- Engenharia colaborativa

**Modelo de Retorno:**

- Portfólio público auditável
- Autoridade técnica
- Networking

**Roadmap:**

- 2026 — Estudar fluxo de contribuição + Fazer PR pequeno (docs, testes, bug simples)
- 2027 — Corrigir bug real + Melhorar feature pequena
- 2028 — Participar de discussão técnica + Refatoração moderada
- 2029 — Contribuição relevante + Talvez maintainership parcial ou feature maior

## Detalhamento de Tarefas

### 🔹 ÉPICO: TECH_STACK (Evolução Técnica)

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| TS-01 | Dominar Linguagem Tipada | Aprofundar em Java (Spring) ou C# (.NET) ou TypeScript (NestJS) com foco em OOP e Design Patterns. | PHASE_2026 |
| TS-02 | SQL Avançado | Stored Procedures, Triggers, Indexing Strategy e Query Optimization. | PHASE_2026 |
| TS-03 | API Design Patterns | Implementar padrões RESTful estritos, HATEOAS e conceitos de Idempotência. | PHASE_2026 |
| TS-04 | Docker & Containerization | Criar Dockerfiles multi-stage otimizados e docker-compose para ambiente dev. | PHASE_2027 |
| TS-05 | Cloud Associate (AWS/Azure) | Estudo para certificação de arquiteto associado (foco em Compute, Storage, Network). | PHASE_2027 |
| TS-06 | Pipeline ETL com Python | Scripting em Python (Pandas/Polars) para processar logs brutos e salvar em banco analítico. | PHASE_2027 |
| TS-07 | AppSec & OWASP Top 10 | Implementar correções para XSS, Injection, Broken Auth no projeto principal. | PHASE_2028 |
| TS-08 | CI/CD Pipelines | Configurar GitHub Actions para testes automáticos, linting e deploy em staging. | PHASE_2028 |
| TS-09 | System Design | Estudar Caching (Redis), Load Balancers, Sharding e Teorema CAP. | PHASE_2029 |

### 🔹 ÉPICO: PORTFOLIO

### Arthemiz

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| PRJ-01.1 | MVP Domínios | Usar CLI em Go para consultar registros (A, CNAME, MX) via Cloudflare API. | PHASE_2026 |
| PRJ-01.2 | Proxy Reverse | Implementar Proxy reverse para logging estruturado. | PHASE_2026 |
| PRJ-01.3 | Autenticação | Auth básica + permissões iniciais. | PHASE_2026 |
| PRJ-01.4 | Segurança | Implementação de Logs de Auditoria (quem alterou o quê e quando). | PHASE_2027 |
| PRJ-01.5 | Vercel Edge Functions | Dashboard para visualizar o status de propagação em diferentes regiões do mundo. | PHASE_2027 |
| PRJ-01.6 | Multi-tenant | Suporte a múltiplos domínios/clientes. | PHASE_2028 |

### OpsLedger

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| PRJ-02.1 | MVP Monólito | API REST em Java (Spring Boot) para cadastro de servidores + recebimento de métricas básicas. | PHASE_2026 |
| PRJ-02.2 | Dashboard React | Dashboard em React + TypeScript com WebSockets para métricas em tempo real. | PHASE_2026 |
| PRJ-02.3 | Autenticação JWT | Implementar JWT + RBAC com roles (ADMIN, USER). Auth básica + permissões. | PHASE_2026 |
| PRJ-02.4 | Deploy | Deploy em AWS EC2 com Docker + Nginx configurado manualmente. | PHASE_2027 |
| PRJ-02.5 | Ingestão Assíncrona | Worker Python + RabbitMQ para processamento de logs/métricas pesadas. | PHASE_2028 |
| PRJ-02.6 | Observabilidade | Integração com Prometheus/Grafana. | PHASE_2028 |
| PRJ-02.7 | Multi-tenant SaaS | Implementar isolamento por cliente. | PHASE_2029 |

#### E-commerce3D

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| PRJ-03.1 | Core Backend & Catálogo | Estruturar API RESTful com modelagem de dados para Produtos, Preços, Materiais (Filamentos) e Variantes (Cores/Tamanhos). | PHASE_2026 |
| PRJ-03.2 | Fila de Produção | Sistema de status `(Pendente -> Imprimindo -> Acabamento -> Enviado)` com notificações e relatórios. | PHASE_2026 |
| PRJ-03.3 | Business Logic | Algoritmo para calcular preço baseado em `(gramas de filamento * custo)` + `(horas  de impressão * custo_energia)` + `margem de lucro`. | PHASE_2027 |
| PRJ-03.4 | Gestão de Inventário & Pedidos | Controle de estoque de filamento. Deduzir gramas do rolo virtual automaticamente após cada pedido confirmado (evitar Race Conditions). Fluxo completo de pedidos. | PHASE_2027 |
| PRJ-03.5 | PCI Compliance e Webhooks | Integração segura com Stripe/Paypal API. Criar endpoint seguro (assinatura HMAC) para receber confirmação de pagamento e liberar pedido na fila. | PHASE_2027 |
| PRJ-03.6 | Hardening de Segurança | Rate limiting, validação de inputs, logs estruturados | PHASE_2028 |
| PRJ-03.7 | API Pública | Endpoints documentados para parceiros e revendedores | PHASE_2029 |
| PRJ-03.8 | White-label | Permitir que outros lojistas usem a plataforma | PHASE_2029 |

#### SystemHealth

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| PRJ-04.1 | MVP Monólito | API CRUD para cadastrar servidores e receber "heartbeats" (sinais de vida). Auth simples. | PHASE_2026 |
| PRJ-04.2 | Front-end Dashboard | Interface em React/Next.js para visualizar status dos servidores em tempo real. | PHASE_2026 |
| PRJ-04.3 | Módulo de Ingestão de Dados | Worker em Python que recebe logs via fila (RabbitMQ) e processa assincronamente. | PHASE_2027 |
| PRJ-04.4 | Deploy Cloud (IaaS) | Subir o projeto em uma VPS (EC2/DigitalOcean) configurando Nginx e firewall Linux manualmente. | PHASE_2027 |
| PRJ-04.5 | Hardening de Segurança | Implementar OAuth2/OIDC, Rate Limiting, rotação de logs e auditoria. | PHASE_2028 |
| PRJ-04.6 | Refatoração Microserviços | Separar o serviço de "Auth" e o de "Ingestão" do monólito principal. | PHASE_2028 |

#### Sentinel Agent

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| PRJ-05.1 | Coleta Local | Coletar CPU, memória e disco via chamadas POSIX/Linux. | PHASE_2027 |
| PRJ-05.2 | Comunicação Socket | Enviar dados via TCP para OpsLedger. | PHASE_2028 |
| PRJ-05.3 | Serialização | Implementar JSON leve ou protocolo binário próprio. | PHASE_2028 |
| PRJ-05.4 | Threads & Concorrência | Coleta paralela de métricas com pthreads. | PHASE_2029 |
| PRJ-05.5 | Hardening & Performance | Otimização de memória + testes de carga + criptografia TLS. | PHASE_2029 |

### Open Source

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| PRJ-06.1 | Hunting | Identificar 3 projetos (ex: NestJS, Spring Security ou Terraform Providers) com a tag `good-first-issue` ou `help-wanted`. Resolver Issues Simples. | PHASE_2026 |
| PRJ-06.2 | Reprodução | Clonar, configurar(Docker) e reproduzir o bug na issue. | PHASE_2027 |
| PRJ-06.3 | Code | Submeter um Pull Request que resolva um bug ou melhore a documentação técnica. | PHASE_2028 |
| PRJ-06.4 | Community | Participar de discussões em Issues ou no Discord oficial do projeto. | PHASE_2028 |
| PRJ-06.5 | Manutenção | Participar de módulos relevantes. | PHASE_2029 |

### 🔹 ÉPICO: LANG_EN (Inglês)

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| EN-01 | Grammar Core | Focar em **Cambridge Grammar in Use** para base | PHASE_2026 |
| EN-02 | Writing Task | Criar textos/redações | PHASE_2026 |
| EN-03 | Listening/Reading | *Shadowing* technique com podcasts como *"Syntax.fm"* para pegar gírias de dev. Ler 1 livro técnico (ex: "Clean Code") em inglês por semestre. | PHASE_2026 |
| EN-04 | Simulados | Realizar testes de nível. | PHASE_2027 |
| EN-05 | Writing Task 2 | Criar documentações técnicas especificas. | PHASE_2027 |
| EN-06 | Diagnóstico IELTS | Aumentar nível. | PHASE_2027 |
| EN-07 | Speaking B2 | Ter fluencia da fala. | PHASE_2027 |
| EN-08 | Certificação IELTS (Treino) | Simulados focados nas bandas 7.5+. | PHASE_2028 |
| EN-09 | Conversação C1/C2 | Aulas de conversação ou prática semanal focada em explicar códigos em inglês. | PHASE_2028 |
| EN-10 | IELTS Oficial | realizar a prova. | PHASE_2029 |

### 🔹 ÉPICO: LANG_JP (Japonês)

---

| ID | Tarefa | Descrição | Fase |
| --- | --- | --- | --- |
| JP-01 | Hiragana/Katakana | Memorização completa dos alfabetos fonéticos. | PHASE_2026 |
| JP-02 | Listening | Método **AJATT (All Japanese All The Time)** para acostumar o ouvido aos fonemas. | PHASE_2026 |
| JP-03 | Kanji Core | Memorização de 500 kanjis via Anki | PHASE_2026 |
| JP-04 | Genki I | Gramática básica e vocabulário de sobrevivência. | PHASE_2027 |
| JP-05 | Genki II | Gramática avançada e vocabulário técnico. | PHASE_2027 |
| JP-06 | Reading | Acostumar com a leitura técnica. | PHASE_2027 |
| JP-07 | Simulados JLPT | Realizar testes de nível. | PHASE_2027 |
| JP-08 | JLPT N4 (Básico Sólido) | Conjugações verbais e partículas complexas. Meta: passar na prova oficial. | PHASE_2027 |
| JP-09 | Grammar N3 | Dominio gramatical completo. | PHASE_2028 |
| JP-10 | JLPT N3 (Intermediário) | Leitura de textos técnicos simples e conversação do dia a dia. | PHASE_2028-29 |
| JP-11 | JLPT Oficial | Realizar a prova. | PHASE_2028 |

## 🎓 Certificações

### Infra/Cloud

**1. AWS Certified Cloud Practitioner** `2026`

- **Foco:** Fácil, para ter o selo inicial e base de conhecimento AWS.

**2. AWS Solutions Architect Associate** `2027`

- **Foco:** Arquitetura resiliente e altamente disponível.
- **Tópicos:** EC2, Load Balancer, Auto Scaling, VPC, Subnets, IAM e Storage (S3, EBS).

**3. Azure Fundamentals (AZ-900)** `2027`

- **Foco:** Arquitetura resiliente e altamente disponível.
- **Tópicos:** EC2, Load Balancer, Auto Scaling, VPC, Subnets, IAM e Storage (S3, EBS).

**4. HashiCorp Terraform Associate** `2027`

- **Foco:** Infraestrutura como Código (IaC). Complementa a arquitetura Cloud.
- **Tópicos:** Workflow, Modules, State Management e Providers.

---

### Segurança

**1. CertiProf Scrum Foundation** `2026`

- **Foco:** Vitória rápida (Quick Win) em Metodologias Ágeis.
- **Tópicos:** Papéis, Artefatos e Cerimônias do Scrum.

**2. CompTIA Security+** `2028`

- **Foco:** Base defensiva de cibersegurança reconhecida globalmente.
- **Tópicos:** Ameaças, ataques, vulnerabilidades, criptografia, PKI, e Segurança de Rede.

**3: CKAD – Certified Kubernetes Application Developer** `2029`

- **Foco:** Deploy e manutenção de aplicações cloud-native em Kubernetes.
- **Tópicos:** Pods, Deployments, ReplicaSets.

---

### Banco de Dados

**1. Oracle Database SQL (1Z0-071)** `2026`

- **Foco:** Domínio absoluto de consultas relacionais.
- **Tópicos:** Junções complexas, subqueries, modelagem de dados, DDL/DML, e controle de transações.

**2. Oracle Certified Associate (Java)** `2026`

- **Foco:** Valida a base da "Linguagem Tipada".
- **Tópicos:** OOP avançado, Java Core, Collections, Exceptions e Streams.

**3. Oracle Certified Professional (Java SE 11/17 Developer)** `2027`

- **Foco:** Padrão ouro corporativo para desenvolvedores Java.
- **Tópicos:** Concorrência, Módulos, I/O, NIO.2, JDBC e Design Patterns aplicados.

**4. VMware Certified Spring Professional** `2028`

- **Foco:** Domínio do framework mais usado no mundo corporativo Java.
- **Tópicos:** Injeção de Dependência, Spring MVC, Spring Security, Spring Data JPA e Spring Boot Actuator.

---

### Específicas para Imigração (Canadá & Japão)

**1. IELTS Oficial (Band 7.0+)** `2028`

- **Foco:** Requisito imigratório e de fluência (C1).

**2. FE (Fundamental Information Technology Engineer Examination)** `2029`

- **Foco:** Prova nacional de TI do Japão. Facilita imensamente o visto (HSP).
- **Tópicos:** Exige N2 de leitura (prova em japonês). Engloba Arquitetura de Computadores, Algoritmos, Estrutura de Dados e Estratégia de Negócios.

## ⏰ Rotina Semanal

Conciliando Faculdade + Trabalho. A chave é **consistência**, não intensidade maluca.

| Turno | Segunda | Terça | Quarta | Quinta | Sexta | Sábado | Domingo |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Manhã** | Trabalho / Java | Trabalho / Oracle | Trabalho / Java | Trabalho / Oracle | Trabalho / Java | **Langs** (2h) - Gramática/Kanji | Descanso / Revisão Semanal |
| **Tarde** | Estágio / Python | Estágio / WEB | Estágio / Python | Estágio / API | Estágio / Python | **Deep Work Tech** (4h) / Projetos | Lazer / Hobby |
| **Noite** | Faculdade | Faculdade | Faculdade | Faculdade | Faculdade | **Social / Livre** Lazer | Planejamento da Semana |
| **Extra** | *Japonês*(Podcast/Kanji) | *Inglês*(Podcast) | *Japonês*(Podcast/Anki) | *Inglês*(Podcast) | *Japonês*(Podcast/Kanji) | - | - |

### Observações

- **Sábado de manhã** para linguagem intensivo (2h de estudo estruturado)
- **Sábado de tarde** é o bloco sagrado para os projetos/SaaS (4h focadas)
- **Tempo morto** (transporte, almoço) para Anki e Podcasts (Syntax/Rebuild).fm
- **Domingo** para descanso real e planejamento da próxima semana

## 🧠 Metodologia de Trabalho

### Princípios

1. **Consistência > Intensidade**
    - Melhor 1h por dia do que 10h no fim de semana
    - Mantenha o ritmo, não o esforço heroico
2. **Projetos Úteis, Evolutivos**
    - Um SaaS que evolui ao longo dos anos
    - Não crie 10 projetos de brinquedo
3. **Fases, não Sprints**
    - Planejamento anual com revisões trimestrais
    - Flexibilidade para ajustar escopo
4. **Certificações como Marcos**
    - Use certificações para validar conhecimento
    - Importantes para visto de trabalho

### Estrutura de Propriedades do Kanban

**Colunas do Database:**

- `ID` (Text) — Identificador único
- `Tarefa` (Title) — Nome da tarefa
- `Descrição` (Text) — Detalhamento
- `Status` (Select) — ⬜ TODO | 🔄 DOING | ✅ DONE
- `Épico` (Select) — TECH_STACK | PORTFOLIO | LANG_EN | LANG_JP | CERTIFICATIONS
- `Fase` (Select) — PHASE_2026 | PHASE_2027 | PHASE_2028 | PHASE_2029
- `Start` (Date) — Data de início
- `End` (Date) — Data de conclusão
- `DoD` (Text) — Definition of Done
- `Obs` (Text) — Observações

### Views Disponíveis

- **📋 Backlog Completo** — Tabela com todas as tarefas
- **📊 Kanban por Status** — Board por Status (workflow diário)
- **🗂 Por Épico** — Tabela agrupada por épico
- **📅 Por Fase** — Board por Fase (visão de longo prazo)

## 📈 Métricas de Sucesso Final (2030)

✅ **Diploma de Ciência da Computação**

✅ **Certificações Profissionais**

✅ **Inglês C1 certificado**

✅ **Japonês N2**

✅ **Projetos completos e em produção:**

- SaaS SystemHealth
- Venda de Produtos 3D
- Arquitetura de microserviços
- Deploy automatizado
- Segurança enterprise
- Documentação completa

✅ **Certificações internacionais:**

- FE (Japão)
- IELTS

✅ **Pronto para visto "High Skilled Professional"**

- Pontuação suficiente no sistema de pontos
- Portfólio sólido
- Idiomas certificados

## 📎 Links

[Kanban](https://www.notion.so/2a8347c6df184054bd0f48ce82d9eb1e?pvs=21)

**Acesso às views:**

- Kanban por Status para execução diária
- Board Por Fase para visão de longo prazo
- Tabela Por Épico para visão modular

---
