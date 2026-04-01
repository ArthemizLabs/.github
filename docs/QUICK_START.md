# Quick Start Guide: GitHub Projects Setup

This guide provides a quick reference for setting up GitHub Projects v2 for the IMMIGRATION_2030 project.

## Prerequisites

1. Create a Personal Access Token (PAT) with these scopes:
   - **If using a classic PAT:**
     - `project` (full access)
     - `read:org`
     - `write:org`
     - `repo` (required for the issue APIs used later in this guide)
   - **If using a fine-grained PAT:**
     - Access to the relevant repositories with:
       - Read and write access to Issues
       - Read and write access to Projects

2. Add the PAT as a repository secret named `PROJECTS_TOKEN`:
   - Go to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `PROJECTS_TOKEN`
   - Value: Your PAT

## Workflow Execution Order

### 1. Setup GitHub Projects (Run First)

**Workflow:** `.github/workflows/setup-projects.yml`

**What it does:**
- Creates 8 GitHub Projects in the organization
- Configures custom fields for each project
- Sets up field options (epic types, phases, priorities, etc.)

**How to run:**
1. Go to Actions → "Setup Projects"
2. Click "Run workflow"
3. Select "all" to create all projects
4. Click "Run workflow"

**Output:**
- Master — Master (with 10 custom fields)
- 6 Product Projects (Arthemiz, OpsLedger, Vendas3D, SystemHealth, Sentinel Agent, Open Source)
- Roadmap — Roadmap (executive dashboard)

**Duration:** ~2-3 minutes

---

### 2. Create Issues from Documentation (Run Second)

**Workflow:** `.github/workflows/create-issues.yml`

**What it does:**
- Uses a predefined list of tasks embedded in the workflow configuration
- Creates GitHub issues for those tasks
- Adds appropriate labels (epic, phase, project)

**How to run:**
1. Go to Actions → "Create Issues"
2. Click "Run workflow"
3. Select "all" to create all issues
4. Set "dry_run" to "false"
5. Click "Run workflow"

**Output:**
- TS-01 to TS-09 (Tech Stack tasks)
- PRJ-01.1 to PRJ-06.5 (Portfolio project tasks)
- EN-01 to EN-10 (English language tasks)
- JP-01 to JP-11 (Japanese language tasks)
- CERT-01 to CERT-12 (Certification tasks)
- Total: ~93 issues

**Duration:** ~3-5 minutes

---

### 3. Add Issues to Projects (Manual or Script)

**Option A: Manual (via GitHub UI)**
1. Go to each Project
2. Click "Add item" (+)
3. Search for issues by ID
4. Add them to the project

**Option B: Automated (via Script)**
```bash
# Make the script executable
chmod +x scripts/add-issues.sh

# Set your token
export PROJECTS_TOKEN=your_token_here

# Run the script
./scripts/add-issues.sh
```

**What the script does:**
- Adds all issues to Master project
- Adds project-specific issues to their respective product projects

**Duration:** ~5-10 minutes (depending on number of issues)

---

### 4. Create Views (Manual - Required)

**Important:** GitHub's API does not support creating views. You must create them manually.

**For Master Project:**
1. Backlog Completo (Table view)
2. Kanban por Status (Board view)
3. Por Épico (Table view)
4. Por Fase (Board view)
5. Roadmap (Roadmap view)

**For Product Projects:**
1. Kanban (Board view)
2. Backlog (Table view)
3. Roadmap do Produto (Roadmap view)

**For Roadmap Project:**
1. Roadmap Executivo (Roadmap view)
2. Por Área (Board view)
3. Backlog (Table view)

See [GITHUB_PROJECTS_SETUP.md](./GITHUB_PROJECTS_SETUP.md) for detailed instructions on creating each view.

**Duration:** ~15-20 minutes

---

### 5. Populate Roadmap Project (Manual)

Add high-level milestones to the Roadmap project:

**Phase Milestones:**
- PHASE_2026 Foundation (2026-01-01 to 2026-12-31)
- PHASE_2027 Expansion (2027-01-01 to 2027-12-31)
- PHASE_2028 Quality & Security (2028-01-01 to 2028-12-31)
- PHASE_2029 Mastery (2029-01-01 to 2029-12-31)

**Language Milestones:**
- IELTS Oficial (PHASE_2028)
- JLPT N4 (PHASE_2027)
- JLPT N3 (PHASE_2028)
- JLPT N2 (PHASE_2029)

**Certification Milestones:**
- FE (Japan) (PHASE_2029)
- High Skilled Professional Readiness (PHASE_2029)

See [GITHUB_PROJECTS_SETUP.md](./GITHUB_PROJECTS_SETUP.md#step-5-populate-roadmap-project) for details.

**Duration:** ~10 minutes

---

## Total Setup Time

- Automated steps: ~10-15 minutes
- Manual steps: ~25-30 minutes
- **Total: ~35-45 minutes**

## Verification Checklist

After completing all steps, verify:

- [ ] All 8 projects exist in the organization
- [ ] Master project has 10 custom fields
- [ ] Product projects have 4 custom fields each
- [ ] Roadmap project has 4 custom fields
- [ ] ~93 issues have been created
- [ ] Issues have appropriate labels (epic, phase, project)
- [ ] Issues are added to their respective projects
- [ ] All views are created and configured
- [ ] Roadmap project has high-level milestones

## Troubleshooting

**Workflow fails:** Check that PROJECTS_TOKEN is set correctly and has the required scopes.

**Issues not created:** Ensure the repository has Issues enabled and GITHUB_TOKEN has `issues: write` permission.

**Cannot add issues to projects:** Verify that the projects exist and you have admin access to the organization.

**Views not appearing:** Views must be created manually in the GitHub UI. The API does not support view creation.

## Next Steps

After setup is complete:

1. Configure custom fields for each issue in the projects
2. Set priorities, dates, and other metadata
3. Start working on tasks and move them through the workflow
4. Use the Roadmap view to track progress across phases

## Additional Resources

- [Full Setup Guide](./GITHUB_PROJECTS_SETUP.md)
- [Project Documentation](../PROJECT_DOCUMENTATION.md)
- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
