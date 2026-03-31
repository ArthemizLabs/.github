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

# Function to get project number by title
get_project_number_by_title() {
  local project_title="$1"

  # Paginate through all Projects v2 to find matching title(s)
  local cursor=""
  local has_next_page=true
  local matching_numbers=()

  while [ "$has_next_page" = true ]; do
    local query
    if [ -z "$cursor" ]; then
      # First page: no "after" cursor
      query='
        query {
          organization(login: "'"$ORG"'") {
            projectsV2(first: 100) {
              nodes {
                title
                number
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
        }
      '
    else
      # Subsequent pages: include "after" cursor
      query='
        query {
          organization(login: "'"$ORG"'") {
            projectsV2(first: 100, after: "'"$cursor"'") {
              nodes {
                title
                number
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
        }
      '
    fi

    local page_json
    page_json=$(gh api graphql -f query="$query")

    # Collect project numbers whose title matches the requested title
    while IFS= read -r number; do
      [ -n "$number" ] && matching_numbers+=("$number")
    done < <(echo "$page_json" | jq -r --arg title "$project_title" '
      .data.organization.projectsV2.nodes[]
      | select(.title == $title)
      | .number
    ')

    # Read pagination info
    has_next_page=$(echo "$page_json" | jq -r '.data.organization.projectsV2.pageInfo.hasNextPage')
    cursor=$(echo "$page_json" | jq -r '.data.organization.projectsV2.pageInfo.endCursor')
  done

  if [ "${#matching_numbers[@]}" -eq 0 ]; then
    echo "❌ Error: No Project v2 found with title \"$project_title\" in organization \"$ORG\"." >&2
    exit 1
  fi

  if [ "${#matching_numbers[@]}" -gt 1 ]; then
    echo "❌ Error: Multiple Projects v2 found with title \"$project_title\" in organization \"$ORG\"." >&2
    echo "   Matching project numbers: ${matching_numbers[*]}" >&2
    echo "   Please ensure project titles are unique." >&2
    exit 1
  fi

  # Exactly one matching project; return its number
  echo "${matching_numbers[0]}"
}

# Alias for backwards compatibility
get_project_id() { get_project_number_by_title "$@"; }

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

  # Treat missing or null project ID as an error
  if [ -z "$project_id" ] || [ "$project_id" = "null" ]; then
    echo "Error: Could not find project with number $project_number in organization $ORG (project ID is null)" >&2
    return 1
  fi
  echo "$project_id"
}

# Function to add issue to project
add_issue_to_project() {
  local issue_number="$1"
  local project_id="$2"

  # Get issue node ID
  local issue_id=$(gh api repos/"$ORG"/"$REPO"/issues/"$issue_number" --jq '.node_id')

  # Add issue to project (idempotent - skip if already added)
  local result
  if result=$(gh api graphql -f query='
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
  ' 2>&1); then
    echo "Added issue #$issue_number to project"
  else
    if echo "$result" | grep -qi "already\|exists\|duplicate"; then
      echo "Issue #$issue_number already in project, skipping"
    else
      echo "Error adding issue #$issue_number: $result" >&2
      return 1
    fi
  fi
}

# Function to add issues by label to a project
add_issues_by_label() {
  local label="$1"
  local project_title="$2"

  echo "Adding issues with label '$label' to project '$project_title'..."

  # Get project number
  local project_number=$(get_project_number_by_title "$project_title")

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
