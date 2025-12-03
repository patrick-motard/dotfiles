---
description: Analyze Jira epic status and remaining work with prioritized breakdown
---

# Epic Status Analysis

You are analyzing a Jira epic to understand what work remains and provide a prioritized breakdown.

## Task

The user has provided a Jira epic key (e.g., PUFFINS-1243, TEAM-456). Your goal is to:

1. **Fetch all tickets in the epic** using `acli jira workitem search`
2. **View details** for non-resolved tickets to understand scope and dependencies
3. **Categorize and prioritize** tickets by status and logical order
4. **Identify the critical path** and any blockers
5. **Present findings** in a clear, actionable format

## Steps

### 1. Fetch Epic Tickets

Use the command:
```bash
acli jira workitem search --jql "parent=EPIC-KEY" --fields "key,summary,status,priority,assignee" --paginate
```

Replace `EPIC-KEY` with the actual epic key provided by the user.

### 2. View Epic Context

Get the epic's summary and status:
```bash
acli jira workitem view EPIC-KEY
```

### 3. Analyze Non-Resolved Tickets

For each ticket that is NOT in "Resolved" status, fetch details:
```bash
acli jira workitem view TICKET-KEY
```

Focus on tickets in these states:
- In Progress
- Shipping
- Review
- Blocked
- Intake
- Backlog

### 4. Categorize and Prioritize

Organize tickets into logical groups:

**Active Work** (In Progress, Shipping, Review)
- List who's working on what
- Note if any are ready for next steps

**Blocked** (Blocked status)
- Identify what's blocking them
- Note dependencies

**Ready for Work** (Intake)
- Order by logical dependencies
- Identify prerequisites

**Future Work** (Backlog)
- Lower priority items
- Nice-to-haves

### 5. Present Findings

Structure your response as:

```markdown
## High Priority / Active Work
1. TICKET-KEY - Summary (Status)
   - Key context
   - Next steps

## Blocked / Needs Resolution
...

## Ready for Intake (Logical Order)
...

## Lower Priority / Nice-to-Have (Backlog)
...

**Summary**: X tickets remaining with Y actively in progress. Critical path: ...
```

## Tips

- Run multiple `acli jira workitem view` commands in parallel when checking ticket details
- Look for dependency relationships mentioned in ticket descriptions
- Identify the critical path through the work
- Note any tickets that are blocking others
- Be concise but informative in your analysis

## Example Usage

```
User: /_epic-status PUFFINS-1243
Claude: [Executes workflow and presents organized breakdown]
```

## Notes

- This command works with any Jira epic key format (TEAM-123, PROJ-456, etc.)
- Requires `acli` (Atlassian CLI) to be installed and authenticated
- If `acli` commands fail, suggest user check authentication: `acli jira auth`
