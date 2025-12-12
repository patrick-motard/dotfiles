---
description: Create a Jira ticket with intelligent parent epic discovery and linking
tags: [jira, automation, workflow]
---

# Create Related Jira Ticket

Create a new Jira task with intelligent parent epic discovery and optional linking to related tickets.

## Workflow

### 1. Gather Information

Ask the user for the following information (be conversational, don't just list questions):

**Required:**
- **Summary**: The ticket title/summary
- **Epic identifier**: One of:
  - Epic ticket ID (e.g., "PUFFINS-1074")
  - Related ticket ID to copy parent from (e.g., "same as PUFFINS-1555")
  - Epic keywords/description (e.g., "growth engine performance")
  - Epic URL (e.g., "https://zendesk.atlassian.net/browse/PUFFINS-1074")
- **Project key**: The Jira project (e.g., "PUFFINS")

**Optional:**
- **Description**: Full ticket description (offer to help draft if not provided)
- **Link to ticket**: Another ticket to link to (e.g., "PUFFINS-1555")
- **Link type**: Type of link (Blocks, Relates, etc.) - default to "Blocks" if linking

### 2. Discover Parent Epic

Use the epic identifier to find the parent:

**If epic ticket ID provided (e.g., "PUFFINS-1074"):**
```bash
acli jira workitem view PUFFINS-1074 --fields '*all' --json | jq -r '.fields.issuetype.name'
```
- Verify it's an Epic type
- Use directly as parent

**If related ticket ID provided (e.g., "same as PUFFINS-1555"):**
```bash
acli jira workitem view PUFFINS-1555 --fields '*all' --json | jq -r '.fields.parent.key'
```
- Extract parent key
- Verify parent exists

**If epic URL provided:**
- Extract ticket ID from URL
- Follow "epic ticket ID" flow above

**If keywords provided (e.g., "growth engine performance"):**
```bash
acli jira workitem search --jql "project=PUFFINS AND issuetype=Epic AND summary~'<keywords>'" --json | jq -r '.[] | "\(.key): \(.fields.summary)"'
```
- Show matching epics to user
- Ask user to select one
- Use selected epic as parent

**If no parent found or ambiguous:**
- Show candidates if any
- Ask user to clarify or provide epic ticket ID

### 3. Prepare Description

If user didn't provide full description, create a temporary file:
```bash
cat > /tmp/ticket-description.txt << 'EOF'
<description content here>
EOF
```

Use markdown formatting (##, **, bullet lists) - NOT Confluence h2/h1 syntax.

### 4. Create the Ticket

**Always create as type "Task"** (project convention).

Create JSON for ticket creation:
```bash
cat > /tmp/new-ticket.json << 'EOF'
{
  "projectKey": "<PROJECT>",
  "type": "Task",
  "summary": "<SUMMARY>",
  "description": {
    "type": "doc",
    "version": 1,
    "content": [
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "See description"
          }
        ]
      }
    ]
  },
  "additionalAttributes": {
    "parent": {
      "key": "<PARENT_EPIC_KEY>"
    }
  }
}
EOF
acli jira workitem create --from-json /tmp/new-ticket.json
```

Capture the created ticket ID from output (e.g., "PUFFINS-1557").

If description was provided, update the ticket:
```bash
acli jira workitem edit --key <NEW_TICKET_KEY> --description-file /tmp/ticket-description.txt --yes
```

### 5. Create Links (if requested)

If user wants to link to another ticket:
```bash
acli jira workitem link create --out <SOURCE_TICKET> --in <NEW_TICKET> --type "<LINK_TYPE>" --yes
```

**Link direction:**
- `--out <SOURCE> --in <TARGET> --type "Blocks"` means SOURCE blocks TARGET
- Example: `--out PUFFINS-1555 --in PUFFINS-1556 --type "Blocks"` means 1555 must complete before 1556

**Common link types:**
- **Blocks**: Source must be completed before target can start
- **Relates**: General relationship between tickets
- **Depends On**: Target depends on source

### 6. Verify and Report

Verify the ticket was created correctly:
```bash
# Check parent was set
acli jira workitem view <NEW_TICKET_KEY> --fields '*all' --json | jq -r '.fields.parent.key'

# Check links if created
acli jira workitem link list --key <NEW_TICKET_KEY> --json | jq
```

Report to user:
- ✅ Created ticket: `<NEW_TICKET_KEY>`
- ✅ URL: `https://zendesk.atlassian.net/browse/<NEW_TICKET_KEY>`
- ✅ Parent: `<PARENT_EPIC_KEY>`
- ✅ Links: (if any) `<SOURCE> Blocks <TARGET>`

## Important Notes

- **Always use `--fields '*all'`** when viewing tickets to get parent field
- **Type is always "Task"** (project convention - stories should be tasks)
- **Parent must be Epic type** - Jira hierarchy: Epic → Task → Sub-task
- **Use markdown formatting** in descriptions (##, **, bullets) not h2/h1
- **Link direction matters**: "X blocks Y" means X must complete first

## Error Handling

**If parent epic doesn't exist:**
- Ask user to provide valid epic ID or create epic first

**If hierarchy error (e.g., "does not belong to appropriate hierarchy"):**
- Check that parent is Epic type, not Task type
- Verify target type is Task or Sub-task, not Story

**If link creation fails:**
- Verify both tickets exist
- Check link type is valid (use `acli jira workitem link type` to list)

## Example Session

```
User: Create a follow-up ticket to remove the billing solution
Claude: I'll help create a related ticket. Let me gather some details:

What should the summary be?
User: Remove PUFFINS-1522 solution from billing to restore latency

Which epic should this belong to? You can provide:
- Epic ticket ID
- A related ticket to copy the parent from (e.g., "same as PUFFINS-1522")
- Keywords to search for the epic
User: same as PUFFINS-1522

Should I link this to another ticket?
User: Yes, link to PUFFINS-1555, it should block this one

[Claude discovers parent PUFFINS-1074 from PUFFINS-1522]
[Claude creates ticket with parent]
[Claude creates "Blocks" link: PUFFINS-1555 blocks new ticket]

✅ Created PUFFINS-1556: Remove PUFFINS-1522 solution from billing to restore latency
✅ URL: https://zendesk.atlassian.net/browse/PUFFINS-1556
✅ Parent: PUFFINS-1074
✅ Link: PUFFINS-1555 Blocks PUFFINS-1556
```
