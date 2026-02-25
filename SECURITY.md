# Security Policy

## Responsible Disclosure Policy

ArthemizLabs takes the security of its systems and its users' data seriously. We welcome responsible disclosure from the security community.

If you have discovered a security vulnerability in any ArthemizLabs system, please report it privately. We are committed to working with security researchers to verify, address, and acknowledge valid reports in a timely manner.

**Do not disclose vulnerabilities publicly until we have had a reasonable opportunity to investigate and remediate the issue.**

---

## Supported Versions

Security patches are applied to the following release lines:

| Version | Supported |
|---|---|
| Latest stable release | Supported |
| Previous minor release | Supported (critical fixes only) |
| Older releases | Not supported |

Each repository maintains its own versioning. Refer to the specific repository's release history to determine the current stable release.

---

## Reporting a Vulnerability

To report a security vulnerability, use one of the following channels:

**GitHub Private Security Advisory (preferred)**
Use the "Report a vulnerability" feature available on the Security tab of the affected repository. This allows for private, structured disclosure directly within GitHub.

**Email**
If GitHub's private advisory feature is unavailable or inappropriate, send a detailed report to the security contact listed in the affected repository's README or in the organization profile.

### What to Include in Your Report

Provide as much of the following as possible to help us triage and respond efficiently:

- A clear description of the vulnerability and its potential impact
- The affected service, repository, and version
- Steps to reproduce the issue, including proof-of-concept code or payloads if applicable
- Any indicators of exploitation or active abuse you are aware of
- Your recommended remediation, if any

### Response Timeline

| Stage | Target Timeline |
|---|---|
| Acknowledgement of receipt | Within 2 business days |
| Initial severity assessment | Within 5 business days |
| Remediation plan communicated | Within 10 business days |
| Patch or mitigation released | Dependent on severity and complexity |

We follow a coordinated disclosure model. Once a fix is available, we will notify you before public disclosure and, where appropriate, credit your contribution in the release notes.

---

## Scope

The following are in scope for responsible disclosure:

- All services and APIs published under the ArthemizLabs organization
- Authentication, authorization, and session management flows
- Data access controls and tenant isolation mechanisms
- Infrastructure components operated by ArthemizLabs

The following are out of scope:

- Social engineering attacks against ArthemizLabs personnel
- Physical security attacks
- Denial-of-service attacks
- Findings from automated scanners without evidence of exploitability
- Vulnerabilities in third-party services not under ArthemizLabs' control

---

## Security Hardening and Non-Sensitive Concerns

For non-sensitive security concerns — such as dependency advisory upgrades or hardening requests — open an issue using the [Security Issue template](./.github/ISSUE_TEMPLATE/security_issue.yml).
