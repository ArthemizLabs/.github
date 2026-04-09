# Project Guidelines

## Commit Messages

When suggesting or generating commit messages, always follow the Conventional Commits 1.0.0 standard used in [CONTRIBUTING.md](../CONTRIBUTING.md).

- Use a valid type such as `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, or `revert`.
- Include a scope when it adds clarity, for example `feat(auth): ...`.
- Description should be concise and short.
- Keep the summary EXTRA short, imperative, and lowercase unless a proper noun requires otherwise, reference only the main changes.
- Use `!` and a `BREAKING CHANGE:` footer when the change is breaking.

## Pull Requests

When generating a pull request title and description, use the repository's PR template in [PULL_REQUEST_TEMPLATE.md](./PULL_REQUEST_TEMPLATE.md), and keep the text concise and specific.

- Title must follow this format: `<type>(<scope>): <short description>`.
- Title type must be one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`.
- Title should be short, imperative, and lowercase unless a proper noun requires otherwise.
- Description should generally follow the sections from the PR template, such as: `Summary`, `What was implemented?`, `Security Impact`, `Breaking Changes`, and `Tests Added`.
- You may omit sections that are not applicable (especially for small or low-impact changes), but keep the description clear and compact.

## Auditorias obrigatórias (commits e PRs)

Antes de sugerir, gerar ou finalizar qualquer **mensagem de commit** ou **título/descrição de PR**, faça **uma auditoria** usando os playbooks base:

- `.github/security-auditor.md` (segurança)
- `.github/code-auditor.md` (qualidade/arquitetura)

### Regras

- **Sempre declarar o escopo da auditoria**: *"Local Dev"* ou *"Pre-Deploy"* (pergunte ao usuário se não estiver claro).
- **Detectar a stack** e executar **somente os módulos relevantes**, com a exceção de:
  - `security-auditor`: sempre executar os Módulos **1, 7, 8 e 9**.
- **Sempre mostrar evidências**: incluir caminhos reais e trechos reais de código/config.
- **Nunca vazar segredos**: mascarar valores como `sk-****`/`ghp_****`/`[REDACTED]`.
- **Classificar severidade** (Critical/High/Medium/Low) para segurança e (✅/⚠️/❌) para qualidade.

### Saída mínima exigida

- Para **segurança**: gerar um *Security Report* no formato definido em `.github/security-auditor.md`.
- Para **qualidade**: gerar um *Code Audit Report* no formato definido em `.github/code-auditor.md`.

### Condição para prosseguir

- Se houver qualquer finding **CRITICAL** (segurança) ou **❌ Fail** (qualidade) relacionado à mudança proposta, **não prosseguir** com a geração do commit/PR até:
  - aplicar a correção, ou
  - obter confirmação explícita do usuário de que aceita o risco (e registrar isso no texto do PR em *Security Impact* / *Breaking Changes*, quando aplicável).
- Em caso de falhas de segurança graves, como exposição de tokens ou secrets por exemplo, bloquear PR's.
