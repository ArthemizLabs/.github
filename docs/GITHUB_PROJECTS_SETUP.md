# GitHub Projects Setup Guide

This guide explains how to set up GitHub Projects v2 for the IMIGRATION_2030 project based on the PROJECT_DOCUMENTATION.md.

## Overview

The setup includes:

1. **8 GitHub Projects:**
   - Master — Master (comprehensive project tracker)
   - Arthemiz — Project
   - OpsLedger — Project
   - Vendas3D — Project
   - SystemHealth — Project
   - Sentinel Agent — Project
   - Open Source — Project
   - Roadmap — Roadmap (executive dashboard)

2. **Custom Fields** for each project
3. **GitHub Issues** generated from PROJECT_DOCUMENTATION.md
4. **Views** (must be created manually)

## Prerequisites

Before running the workflows, you need to:

1. **Create a Personal Access Token (PAT)** with the following scopes:
   - `project` (full access)
   - `read:org`
   - `write:org`

2. **Add the PAT as a repository secret:**
   - Go to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `PROJECTS_TOKEN`
   - Value: Your PAT from step 1

## Step 1: Create GitHub Projects

Run the "Setup GitHub Projects v2" workflow:

1. Go to **Actions** tab
2. Select **Setup GitHub Projects v2** workflow
3. Click **Run workflow**
4. Select which projects to create:
   - `all` - Create all 8 projects (recommended for first run)
   - `master-only` - Create only the Master project
   - `products-only` - Create only the product projects
   - `roadmap-only` - Create only the Roadmap project
5. Click **Run workflow**

The workflow will:
- Create all selected projects in the organization
- Configure custom fields for each project
- Add appropriate options to single-select fields

### Master Project Fields

The Master project includes these custom fields:

- **ID** (text) - Task identifier (e.g., TS-01, PRJ-02.3)
- **Épico** (single select) - TECH_STACK, PORTFOLIO, LANG_EN, LANG_JP, CERTIFICATIONS
- **Fase** (single select) - PHASE_2026, PHASE_2027, PHASE_2028, PHASE_2029
- **Projeto** (single select) - Arthemiz, OpsLedger, Vendas3D, SystemHealth, Sentinel Agent, Open Source, Geral
- **Status** (native field) - TODO, DOING, DONE, BLOCKED
- **Start** (date) - Start date
- **End** (date) - End date
- **DoD** (text) - Definition of Done
- **Obs** (text) - Observations/notes
- **Tipo** (single select) - Study, Feature, Infra, Security, Certification, Docs, Bug

### Product Projects Fields

Each product project (Arthemiz, OpsLedger, Vendas3D, SystemHealth, Sentinel Agent, Open Source) includes:

- **Status** (native field) - TODO, DOING, DONE
- **Prioridade** (single select) - P0, P1, P2, P3
- **Sprint/Trimestre** (single select) - 2026-Q2 through 2029-Q4
- **Start** (date) - Start date
- **End** (date) - End date

### Roadmap Project Fields

The Roadmap project includes:

- **Status** (native field) - TODO, DOING, DONE
- **Fase** (single select) - PHASE_2026, PHASE_2027, PHASE_2028, PHASE_2029
- **Start** (date) - Start date
- **End** (date) - End date
- **Área** (single select) - Carreira, Idiomas, Certificações, Portfólio, Segurança/Qualidade

## Step 2: Create GitHub Issues

Run the "Create Issues from Documentation" workflow:

1. Go to **Actions** tab
2. Select **Create Issues from Documentation** workflow
3. Click **Run workflow**
4. Select which epic to create issues for:
   - `all` - Create all issues (recommended)
   - `TECH_STACK` - Only tech stack tasks (TS-01 to TS-09)
   - `PORTFOLIO` - Only portfolio tasks (all project tasks)
   - `LANG_EN` - Only English language tasks (EN-01 to EN-10)
   - `LANG_JP` - Only Japanese language tasks (JP-01 to JP-11)
5. Set `dry_run` to:
   - `true` - Preview what would be created without actually creating issues
   - `false` - Actually create the issues
6. Click **Run workflow**

The workflow will create issues with:
- Title format: `[ID] Task Title`
- Labels: epic, phase, and project labels
- Description: Task ID, phase, project (if applicable), and detailed description

### Issue Labels

Issues are automatically labeled with:

- **Epic labels:**
  - `epic:tech-stack` - Technical stack evolution tasks
  - `epic:portfolio` - Portfolio project tasks
  - `epic:lang-en` - English language tasks
  - `epic:lang-jp` - Japanese language tasks

- **Phase labels:**
  - `phase-2026` - Foundation phase
  - `phase-2027` - Expansion phase
  - `phase-2028` - Quality & Security phase
  - `phase-2029` - Mastery phase

- **Project labels:**
  - `project:arthemiz`
  - `project:opsledger`
  - `project:vendas3d`
  - `project:systemhealth`
  - `project:sentinel-agent`
  - `project:open-source`

## Step 3: Create Views (Manual)

**Important:** GitHub's API does not support creating views programmatically. You must create these manually in the GitHub UI.

### Master Project Views

Create these views in the Master project:

1. **Backlog Completo** (Table view)
   - Layout: Table
   - Group by: None
   - Sort by: Fase (ascending), then ID (ascending)
   - Show all fields

2. **Kanban por Status** (Board view)
   - Layout: Board
   - Group by: Status
   - Show: ID, Épico, Fase, Projeto, Start, End

3. **Por Épico** (Table view)
   - Layout: Table
   - Group by: Épico
   - Sort by: Fase, then ID
   - Show all fields

4. **Por Fase** (Board view)
   - Layout: Board
   - Group by: Fase
   - Show: ID, Épico, Projeto, Status

5. **Roadmap** (Roadmap view)
   - Layout: Roadmap
   - Date fields: Start and End
   - Group by: Fase or Épico
   - Note: If Start is empty, the item will use End date

### Product Project Views

Create these views in each product project:

1. **Kanban** (Board view)
   - Layout: Board
   - Group by: Status
   - Show: Prioridade, Sprint/Trimestre, Start, End

2. **Backlog** (Table view)
   - Layout: Table
   - Group by: None
   - Sort by: Prioridade, then Sprint/Trimestre
   - Show all fields

3. **Roadmap do Produto** (Roadmap view)
   - Layout: Roadmap
   - Date fields: Start and End
   - Group by: Sprint/Trimestre

### Roadmap Project Views

Create these views in the Roadmap project:

1. **Roadmap Executivo** (Roadmap view)
   - Layout: Roadmap
   - Date fields: Start and End
   - Group by: Fase

2. **Por Área** (Board view)
   - Layout: Board
   - Group by: Área
   - Show: Fase, Status, Start, End

3. **Backlog** (Table view)
   - Layout: Table
   - Group by: Fase
   - Sort by: Start date
   - Show all fields

## Step 4: Add Issues to Projects

After creating issues, you need to add them to the appropriate projects:

### Option 1: Manual Addition (via GitHub UI)

1. Go to the Project
2. Click "Add item" (+)
3. Search for the issue by ID or title
4. Add it to the project
5. Fill in the custom fields

### Option 2: Bulk Addition (via GitHub CLI)

You can use the GitHub CLI to add issues in bulk. Here's an example script:

```bash
#!/bin/bash

# Get project ID
PROJECT_ID=$(gh api graphql -f query='
  query {
    organization(login: "ArthemizLabs") {
      projectV2(number: 1) {
        id
      }
    }
  }
' --jq '.data.organization.projectV2.id')

# Get all issues with a specific label
gh issue list --label "epic:tech-stack" --json number,id --jq '.[] | @json' | while read issue; do
  ISSUE_ID=$(echo "$issue" | jq -r '.id')

  # Add issue to project
  gh api graphql -f query='
    mutation {
      addProjectV2ItemById(input: {
        projectId: "'"$PROJECT_ID"'"
        contentId: "'"$ISSUE_ID"'"
      }) {
        item {
          id
        }
      }
    }
  '
done
```

## Step 5: Populate Roadmap Project

The Roadmap project should contain high-level milestones. Create these items manually:

### Phase Milestones

1. **PHASE_2026 Foundation**
   - Status: DOING
   - Fase: PHASE_2026
   - Start: 2026-01-01
   - End: 2026-12-31
   - Área: Carreira

2. **PHASE_2027 Expansion**
   - Status: TODO
   - Fase: PHASE_2027
   - Start: 2027-01-01
   - End: 2027-12-31
   - Área: Carreira

3. **PHASE_2028 Quality & Security**
   - Status: TODO
   - Fase: PHASE_2028
   - Start: 2028-01-01
   - End: 2028-12-31
   - Área: Segurança/Qualidade

4. **PHASE_2029 Mastery**
   - Status: TODO
   - Fase: PHASE_2029
   - Start: 2029-01-01
   - End: 2029-12-31
   - Área: Carreira

### Language Milestones

1. **IELTS Oficial (Band 7.0+)**
   - Status: TODO
   - Fase: PHASE_2028
   - Start: 2028-06-01
   - End: 2028-09-01
   - Área: Idiomas

2. **JLPT N4**
   - Status: TODO
   - Fase: PHASE_2027
   - Start: 2027-07-01
   - End: 2027-12-01
   - Área: Idiomas

3. **JLPT N3**
   - Status: TODO
   - Fase: PHASE_2028
   - Start: 2028-07-01
   - End: 2028-12-01
   - Área: Idiomas

4. **JLPT N2**
   - Status: TODO
   - Fase: PHASE_2029
   - Start: 2029-07-01
   - End: 2029-12-01
   - Área: Idiomas

### Certification Milestones

1. **FE (Japan)**
   - Status: TODO
   - Fase: PHASE_2029
   - Start: 2029-04-01
   - End: 2029-10-01
   - Área: Certificações

2. **High Skilled Professional Readiness**
   - Status: TODO
   - Fase: PHASE_2029
   - Start: 2029-01-01
   - End: 2029-12-31
   - Área: Carreira

## Troubleshooting

### Workflow Fails with "PROJECTS_TOKEN is invalid"

1. Verify that you created the PAT with the correct scopes
2. Check that the secret is named exactly `PROJECTS_TOKEN`
3. Make sure the PAT hasn't expired

### Issues Not Created

1. Check the workflow logs for error messages
2. Verify that the repository has Issues enabled
3. Ensure the GITHUB_TOKEN has `issues: write` permission

### Cannot Create Views

This is expected. GitHub's API does not support creating views. You must create them manually in the UI.

### Fields Not Appearing

1. Refresh the project page
2. Check that the workflow completed successfully
3. Verify the field was created by checking the project settings

## Additional Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [GitHub GraphQL API](https://docs.github.com/en/graphql)
- [PROJECT_DOCUMENTATION.md](../PROJECT_DOCUMENTATION.md)

## Support

If you encounter issues:

1. Check the workflow logs for detailed error messages
2. Review this guide for troubleshooting steps
3. Open an issue in the repository with:
   - The workflow name
   - Error messages from the logs
   - Steps to reproduce
