#!/bin/bash
# Script to add GitHub issues to Projects v2
# Usage: ./add-issues.sh

set -e

# Configuration
ORG="ArthemizLabs"
REPO=".github"

# Check if PROJECTS_TOKEN is set
if [ -z "$PROJECTS_TOKEN" ]; then
  echo "Error: PROJECTS_TOKEN environment variable is not set"
  echo "Please set it with: export PROJECTS_TOKEN=your_token_here"
  exit 1
fi

export GH_TOKEN="$PROJECTS_TOKEN"

# Function to get project ID by title
get_project_id() {
  local project_title="$1"
  local project_number=$(gh api graphql -f query='
    query {
      organization(login: "'"$ORG"'") {
        projectsV2(first: 20) {
          nodes {
            id
            title
            number
          }
        }
      }
    }
  ' --jq '.data.organization.projectsV2.nodes[] | select(.title == "'"$project_title"'") | .number')

  echo "$project_number"
}

# Function to get project node ID by number
get_project_node_id() {
  local project_number="$1"
  local project_id=$(gh api graphql -f query='
    query {
      organization(login: "'"$ORG"'") {
        projectV2(number: '"$project_number"') {
          id
        }
      }
    }
  ' --jq '.data.organization.projectV2.id')

  echo "$project_id"
}

# Function to add issue to project
add_issue_to_project() {
  local issue_number="$1"
  local project_id="$2"

  # Get issue node ID
  local issue_id=$(gh api repos/"$ORG"/"$REPO"/issues/"$issue_number" --jq '.node_id')

  # Add issue to project
  gh api graphql -f query='
    mutation {
      addProjectV2ItemById(input: {
        projectId: "'"$project_id"'"
        contentId: "'"$issue_id"'"
      }) {
        item {
          id
        }
      }
    }
  ' --silent

  echo "Added issue #$issue_number to project"
}

# Function to add issues by label to a project
add_issues_by_label() {
  local label="$1"
  local project_title="$2"

  echo "Adding issues with label '$label' to project '$project_title'..."

  # Get project number
  local project_number=$(get_project_id "$project_title")

  if [ -z "$project_number" ]; then
    echo "Error: Project '$project_title' not found"
    return 1
  fi

  echo "   Project number: $project_number"

  # Get project node ID
  local project_id=$(get_project_node_id "$project_number")

  if [ -z "$project_id" ]; then
    echo "Error: Could not get project ID"
    return 1
  fi

  echo "   Project ID: $project_id"

  # Get all issues with the label
  local issues=$(gh issue list --repo "$ORG/$REPO" --label "$label" --limit 1000 --json number --jq '.[].number')

  if [ -z "$issues" ]; then
    echo "   No issues found with label '$label'"
    return 0
  fi

  local count=0
  for issue_number in $issues; do
    add_issue_to_project "$issue_number" "$project_id"
    count=$((count + 1))
    sleep 0.5  # Rate limiting
  done

  echo "Added $count issues to project '$project_title'"
}

# Main script
echo "GitHub Projects Issue Importer"
echo "=================================="
echo ""

# Add all issues to Master project
echo "1️Adding all issues to Master project..."
add_issues_by_label "epic:tech-stack" "Master — Master"
add_issues_by_label "epic:portfolio" "Master — Master"
add_issues_by_label "epic:lang-en" "Master — Master"
add_issues_by_label "epic:lang-jp" "Master — Master"
echo ""

# Add project-specific issues to product projects
echo "2️Adding project-specific issues to product projects..."
add_issues_by_label "project:arthemiz" "Arthemiz — Project"
add_issues_by_label "project:opsledger" "OpsLedger — Project"
add_issues_by_label "project:vendas3d" "Vendas3D — Project"
add_issues_by_label "project:systemhealth" "SystemHealth — Project"
add_issues_by_label "project:sentinel-agent" "Sentinel Agent — Project"
add_issues_by_label "project:open-source" "Open Source — Project"
echo ""

echo "Done! All issues have been added to their respective projects."
echo ""
echo "Next steps:"
echo "1. Go to each project and configure the custom fields for each issue"
echo "2. Create the views as described in docs/GITHUB_PROJECTS_SETUP.md"
echo "3. Manually add high-level milestones to the Roadmap project"
