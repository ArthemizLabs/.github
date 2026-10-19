# ArthemizLabs · `.github`

Repositório de governança da organização **ArthemizLabs**. Guarda os padrões que valem para todos os repositórios: templates, workflows reutilizáveis, políticas, o perfil público da org e o site [site.arthemiz.com.br](https://site.arthemiz.com.br).

> 🇺🇸 *Governance repository for the ArthemizLabs organization: shared templates, reusable workflows, policies, the public org profile and the website. An English summary is at the end of this file.*

---

## O que tem aqui

| Caminho | Conteúdo |
| --- | --- |
| [`profile/README.md`](./profile/README.md) | Perfil público exibido em [github.com/ArthemizLabs](https://github.com/ArthemizLabs) |
| [`site/`](./site/) | Site estático da org (HTML/CSS puro, bilíngue PT/EN), publicado no GitHub Pages |
| [`.github/ISSUE_TEMPLATE/`](./.github/ISSUE_TEMPLATE/) | Templates de bug, feature, discussão de arquitetura e segurança |
| [`.github/PULL_REQUEST_TEMPLATE.md`](./.github/PULL_REQUEST_TEMPLATE.md) | Template padrão de PR |
| [`.github/workflows/`](./.github/workflows/) | Workflows reutilizáveis e automações da org |
| [`docs/`](./docs/) | Documentação de GitHub Projects e planejamento |
| [`examples/`](./examples/) | Exemplos de uso dos workflows em outros repositórios |
| [`CONTRIBUTING.md`](./CONTRIBUTING.md) · [`SECURITY.md`](./SECURITY.md) · [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md) | Políticas da organização |

## Projetos da organização

**Em produção e em uso:** Simulador PROMOVE, cobranca-app, Portal Serviços Goiás, Comparador SEAD. **Públicos:** [biblio-system](https://github.com/ArthemizLabs/biblio-system), [jornada-dev](https://github.com/ArthemizLabs/jornada-dev).

**Projetos de estudo (futuros, ainda sem produção):** OpsLedger, Sentinel Agent, SystemHealth e Vendas3D. Cada um existe para aprender uma tecnologia específica e está no [roadmap](https://site.arthemiz.com.br/roadmap.html).

Detalhes no [perfil da org](./profile/README.md).

## Workflows reutilizáveis

Chamados de outros repositórios via `workflow_call`. Fixe sempre uma tag ou SHA.

| Workflow | O que faz |
| --- | --- |
| [`ci.yml`](./.github/workflows/ci.yml) | Detecta Node.js, Go ou Python e roda lint e testes no diretório informado |
| [`deploy-pages.yml`](./.github/workflows/deploy-pages.yml) | Publica um diretório no GitHub Pages, com build opcional |
| [`validate-read-tokens.yml`](./.github/workflows/validate-read-tokens.yml) | Valida leitura do Projects v2 com o secret `projects_token` |
| [`validate-write-tokens.yml`](./.github/workflows/validate-write-tokens.yml) | Valida escrita no Projects v2 com o secret `projects_token` |

Os arquivos `*-wrapper.yml` usam esses workflows dentro deste próprio repositório (o `deploy-pages-wrapper.yml` publica o `site/` a cada push na `main`). Automações manuais (`workflow_dispatch`): `setup-projects.yml`, `create-issues.yml` e `sync-projects-dates.yml`.

Exemplo (ver [`examples/ci-consumer.yml`](./examples/ci-consumer.yml)):

```yaml
name: CI
on: { pull_request: { branches: [main] } }
jobs:
  ci:
    uses: ArthemizLabs/.github/.github/workflows/ci.yml@<tag-ou-sha>
```

## Padrões

- **Commits:** [Conventional Commits 1.0.0](https://www.conventionalcommits.org/pt-br/v1.0.0/).
- **Branches:** `<tipo>/<descricao-em-kebab-case>`, nome que descreve a mudança.
- **PRs:** título `<tipo>(<escopo>): <descrição>` e seções Summary, Security Impact, Breaking Changes e Tests Added.
- **Versionamento:** [SemVer 2.0.0](https://semver.org/lang/pt-BR/).
- **Segurança:** vulnerabilidades são reportadas em privado, conforme o [SECURITY.md](./SECURITY.md). Nunca em issue pública.

Gestão de trabalho com GitHub Projects v2: veja o [guia de setup](./docs/projects/GITHUB_PROJECTS_SETUP.md).

---

## English summary

This repository holds the ArthemizLabs organization defaults: issue and PR templates, reusable GitHub Actions workflows (`ci.yml`, `deploy-pages.yml`, token validators), contribution/security/conduct policies, the public org profile (`profile/README.md`) and the static bilingual website in `site/`, deployed to GitHub Pages on every push to `main`.

Projects in production or in use: PROMOVE Simulator, cobranca-app, Portal Serviços Goiás and SEAD Comparator. OpsLedger, Sentinel Agent, SystemHealth and Vendas3D are **study projects**, planned for 2027-2029 and not in production.
