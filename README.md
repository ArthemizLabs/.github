# ArthemizLabs

ArthemizLabs is an engineering-driven organization building production-grade SaaS systems across operations management, 3D commerce, security intelligence, and infrastructure observability.

---

## Mission

To design, build, and operate reliable, secure, and scalable SaaS platforms that solve real operational problems for businesses — with engineering rigor, architectural discipline, and a relentless focus on production quality.

---

## Engineering Principles

**Reliability first.** Systems must be designed to fail gracefully. Every service has defined SLOs, circuit breakers, and documented recovery procedures.

**Security by default.** Security is not an afterthought. Threat modeling, secret management, and least-privilege access are requirements at the architecture stage.

**Documentation-driven development.** Architectural decisions are recorded as ADRs. APIs are contract-first. Onboarding must never depend on tribal knowledge.

**Clean Architecture.** Domain logic is decoupled from infrastructure. Dependencies point inward. Each bounded context owns its own data.

**Semantic Versioning.** All services and libraries follow [SemVer 2.0.0](https://semver.org/). Breaking changes are never shipped silently.

**Automation over manual process.** CI/CD pipelines are the only path to production. No human shall push directly to `main` in a production repository.

---

## Ecosystem Overview

| System | Description | Status |
|---|---|---|
| **OpsLedger** | Financial operations and audit ledger platform for SMBs. Double-entry accounting, reconciliation, and compliance reporting. | In Development |
| **Arthemiz** | Core identity, billing, and tenant management layer shared across the ecosystem. Multi-tenant SaaS foundation. | Active |
| **Vendas3D** | 3D product commerce platform. Enables merchants to publish interactive 3D product experiences and manage digital storefronts. | In Development |
| **Sentinel** | Security intelligence and threat monitoring service. Centralized log ingestion, anomaly detection, and alerting. | Not Started |
| **SystemHealth** | Infrastructure observability and health dashboard. Aggregates uptime, latency, error rates, and deployment health across all services. | Not Started |

---

## Contribution Model

ArthemizLabs follows a structured contribution model to maintain code quality and architectural consistency across all repositories.

**Internal contributors** follow the branching strategy and commit conventions defined in [CONTRIBUTING.md](./CONTRIBUTING.md).

**External contributors** are welcome to open issues and submit pull requests. All contributions are reviewed against the engineering principles and architectural standards of the affected system.

All contributors are expected to adhere to the [Code of Conduct](./CODE_OF_CONDUCT.md).

Security vulnerabilities must be reported privately per the [Security Policy](./SECURITY.md). Do not open public issues for security concerns.

---

## Project Management

ArthemizLabs uses GitHub Projects v2 for tracking work across the organization. See [GitHub Projects Setup Guide](./docs/projects/GITHUB_PROJECTS_SETUP.md) for information on:

- Setting up organization-wide projects
- Creating and managing issues from the project documentation
- Configuring custom fields and views
- Tracking progress across phases and epics

The detailed roadmap and task breakdown is documented in [PROJECT_DOCUMENTATION.md](./docs/PROJECT_DOCUMENTATION.md).

## Repository Structure

This repository (`.github`) serves as the engineering governance layer for the ArthemizLabs organization. It contains:

- Organization-wide GitHub defaults (issue templates, PR templates, CI workflows)
- Engineering policies (contributing guidelines, security policy, code of conduct)
- The organization profile (this file)
- GitHub Projects setup automation and documentation

Repository-specific documentation, architecture decision records, and runbooks live in their respective repositories.

### Public Site

The public-facing website is located in the [`site/`](./site/) directory. It contains:

- `site/index.html` — Home page
- `site/architecture.html` — System architecture overview
- `site/roadmap.html` — Engineering roadmap (2026–2029)
- `site/assets/` — Stylesheets and static assets

GitHub Pages is configured to deploy from the `site/` directory on the `main` branch.

### Reusable Workflows

The workflows in `.github/workflows` are ready for reuse via `workflow_call`:

- `ci.yml`: auto-detects Node.js, Go, or Python and runs lint/tests in the specified directory.
- `auto-assign.yml`: assigns owners to incoming issues and pull requests.
- `pages.yml`: publishes artifacts to GitHub Pages, with an optional build step.
- `validade-tokens.yml` and `validar-tokens-escrita.yml`: validate read/write access to Projects v2 using the `projects_token` secret (local wrappers map from `PROJECTS_TOKEN` to keep compatibility).

Example usage (see `examples/ci-consumer.yml`):

```yaml
name: CI
on: { pull_request: { branches: [main] } }
jobs:
  ci:
    uses: ArthemizLabs/.github/.github/workflows/ci.yml@<tag-or-sha>
    # Example: ArthemizLabs/.github/.github/workflows/ci.yml@0123456789abcdef
```

---

*ArthemizLabs — Engineering-driven SaaS.*
