# Project Guidelines

## Commit Messages

When suggesting or generating commit messages, always follow the Conventional Commits 1.0.0 standard used in [CONTRIBUTING.md](../CONTRIBUTING.md).

- Use a valid type such as `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, or `revert`.
- Include a scope when it adds clarity, for example `feat(auth): ...`.
- Keep the summary short, imperative, and lowercase unless a proper noun requires otherwise.
- Use `!` and a `BREAKING CHANGE:` footer when the change is breaking.

## Pull Requests

When generating a pull request title and description, use the repository's PR template and keep the text concise and specific.

- Title should be short and descriptive, preferably aligned with the same Conventional Commits style used for commits, shuch as `feat:`, `fix:`, etc.
- Description should summarize what changed, why it changed, any security or breaking impact, and what tests were added or updated, following the template specified in [PULL_REQUEST_TEMPLATE.md](./PULL_REQUEST_TEMPLATE.md).
- If the change is small, prefer a compact description that fills the template sections without unnecessary detail.