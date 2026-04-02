# Project Guidelines

## Commit Messages

When suggesting or generating commit messages, always follow the Conventional Commits 1.0.0 standard used in [CONTRIBUTING.md](../CONTRIBUTING.md).

- Use a valid type such as `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, or `revert`.
- Include a scope when it adds clarity, for example `feat(auth): ...`.
- Description should be concise and short.
- Keep the summary short, imperative, and lowercase unless a proper noun requires otherwise.
- Use `!` and a `BREAKING CHANGE:` footer when the change is breaking.

## Pull Requests

When generating a pull request title and description, use the repository's PR template in [PULL_REQUEST_TEMPLATE.md](./PULL_REQUEST_TEMPLATE.md) and keep the text concise and specific.

- Title must follow this format: `<type>(<scope>): <short description>`.
- Title type must be one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`.
- Title should be short, imperative, and lowercase unless a proper noun requires otherwise.
- Description should generally follow the sections from the PR template, such as: `Summary`, `What was implemented?`, `Security Impact`, `Breaking Changes`, and `Tests Added`.
- You may omit sections that are not applicable (especially for small or low-impact changes), but keep the description clear and compact.
