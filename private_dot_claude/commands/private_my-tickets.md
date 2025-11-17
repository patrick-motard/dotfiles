---
description: Fetch my active and assigned Jira tickets
---

Fetch and display my active and assigned Jira tickets using the acli tool.

Run this command:
```bash
acli jira workitem search --jql "assignee = currentUser() AND status != Done AND status != Closed AND status != Resolved" --fields "key,summary,status,priority" --paginate
```

After fetching the tickets, provide a clear summary that includes:
1. Total number of active tickets
2. A formatted list of tickets showing:
   - Ticket key (as a clickable reference)
   - Summary
   - Status
   - Priority

If there are no active tickets, let me know. If there's an error (like authentication issues), provide helpful guidance on how to authenticate with `acli jira auth`.
