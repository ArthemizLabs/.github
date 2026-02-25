# Contributing to ArthemizLabs

Thank you for contributing to ArthemizLabs. This document defines the engineering standards and processes that apply to contributions across all repositories in this organization.

All contributors — internal and external — are expected to follow these guidelines.

---

## Branch Strategy

All repositories follow a trunk-based development model with short-lived feature branches.

| Branch | Purpose |
|---|---|
| `main` | Production-ready code. Protected. Direct pushes are not permitted. |
| `feature/<scope>/<short-description>` | New features or capabilities |
| `fix/<scope>/<short-description>` | Bug fixes |
| `chore/<scope>/<short-description>` | Maintenance tasks, dependency updates, tooling |
| `docs/<short-description>` | Documentation-only changes |
| `release/<version>` | Release preparation branches, if applicable |

**Rules:**
- `main` is always deployable. Never merge a branch that does not pass CI.
- Feature branches must be rebased on `main` before opening a pull request.
- Branches must be deleted after merge.
- Avoid long-lived branches. Break large changes into incremental pull requests.

---

## Commit Convention

All commits must follow the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification.

### Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer(s)]
```

### Allowed Types

| Type | When to Use |
|---|---|
| `feat` | A new feature or capability |
| `fix` | A bug fix |
| `docs` | Documentation changes only |
| `style` | Formatting, whitespace — no logic change |
| `refactor` | Code restructuring without behavior change |
| `perf` | Performance improvements |
| `test` | Adding or updating tests |
| `chore` | Build system, dependency updates, tooling |
| `ci` | CI/CD pipeline configuration changes |
| `revert` | Reverting a previous commit |

### Scope

The scope identifies the affected module, service layer, or domain area (e.g., `auth`, `billing`, `api`, `db`, `infra`).

### Breaking Changes

Breaking changes must be declared with a `!` after the type/scope and a `BREAKING CHANGE:` footer:

```
feat(api)!: remove deprecated v1 tenant endpoint

BREAKING CHANGE: The /api/v1/tenants endpoint has been removed. Migrate to /api/v2/tenants.
```

### Examples

```
feat(billing): add proration support for mid-cycle plan changes
fix(auth): resolve token refresh race condition under concurrent requests
docs(api): document rate limiting headers in tenant endpoint reference
chore(deps): upgrade typescript to 5.4.x
ci: add dependency audit step to pull request pipeline
```

---

## Pull Request Process

1. Open a pull request against `main` using the [pull request template](./.github/PULL_REQUEST_TEMPLATE.md).
2. Ensure all CI checks pass before requesting review.
3. At least one approval from a code owner is required before merging.
4. Address all review comments or explicitly resolve them with justification.
5. Use squash merge for feature branches to maintain a clean commit history on `main`.

### Pull Request Size

Keep pull requests focused and reviewable. A pull request should address a single concern. If a change is large, break it into a sequence of smaller pull requests with clear dependency ordering.

---

## Code Review Policy

**Reviewers are responsible for:**
- Verifying correctness of logic and adherence to the architectural patterns of the service
- Identifying security risks or data exposure concerns
- Ensuring tests cover the changed behavior
- Confirming documentation is updated where necessary

**Authors are responsible for:**
- Providing clear context in the PR description
- Responding to review comments within one business day
- Not merging without the required approvals

Reviews should be constructive and specific. Nitpicks should be explicitly labeled as such. Blocking a merge solely on style preferences that are not enforced by the linter is discouraged.

---

## Testing Requirements

All code changes must include appropriate test coverage.

| Change Type | Required Coverage |
|---|---|
| New feature | Unit tests for domain logic; integration tests for API endpoints and database interactions |
| Bug fix | A regression test that fails before the fix and passes after |
| Refactor | All existing tests must pass; no reduction in coverage |
| Configuration / infrastructure | Validation or smoke tests where applicable |

**Minimum standards:**
- Unit tests must be isolated. External dependencies (databases, HTTP clients, queues) must be mocked.
- Integration tests must run against a controlled environment (e.g., a test container or an in-memory store).
- Test file naming must follow the conventions established in each repository.
- Flaky tests are treated as bugs and must be fixed or removed promptly.

---

## Documentation Standards

- API changes must include updates to the corresponding API contract or OpenAPI specification.
- Significant architectural decisions must be recorded as Architecture Decision Records (ADRs) in the affected repository's `docs/adr/` directory.
- Public-facing configuration options must be documented.
- Inline code comments are expected for non-obvious logic. Avoid commenting what the code does — explain why.

---

## Security Responsibilities

- Never commit secrets, credentials, tokens, or private keys to source control.
- Use environment variables or a secrets manager for all sensitive configuration.
- Dependencies must be reviewed for known vulnerabilities before introduction. Use the dependency audit tooling available in each repository's CI pipeline.
- If you discover a security vulnerability while contributing, report it privately per the [Security Policy](./SECURITY.md).

---

## Code of Conduct

All contributors must adhere to the [Code of Conduct](./CODE_OF_CONDUCT.md). Violations may result in removal from the project.
