---
description: Add notes from the current session to the Obsidian wiki with proper linking and discoverability
---

# Add to Wiki

Add the following content to my Obsidian wiki at `~/code/wiki`:

**Topic/Content:** $ARGUMENTS

## Instructions

1. **Explore the wiki structure:**
   - Use the Explore agent to understand the wiki's folder structure and organization
   - Find existing documents related to this topic
   - Identify the main hub page(s) this should link from
   - Note the naming conventions (Title Case with spaces) and linking style (wiki-links `[[Like This]]`)

2. **Determine document placement:**
   - If it fits under an existing category/hub, note which one
   - If it's a standalone topic, place at root level
   - Check for existing related documents to link to

3. **Create the document:**
   - Use proper YAML frontmatter:
     ```yaml
     ---
     type: [note|project|reference|maintenance_log]
     tags:
       - relevant-tag
     parent: "[[Parent Page]]"
     created_date: YYYY-MM-DD
     status: [draft|in_progress|complete]
     ---
     ```
   - Add wiki-links to related documents throughout
   - Include a "Related:" line near the top linking to key related pages
   - Structure with clear headings

4. **Make it discoverable:**
   - Update the parent/hub page to include a link to this new document
   - Add links in any "See also" or related sections of connected documents
   - Ensure it will appear in any relevant Dataview queries (via tags/frontmatter)

5. **Commit and push:**
   - Stage the new file and any modified files
   - Write a clear commit message describing what was documented
   - Push to origin

6. **Report back:**
   - Show the file path created
   - List the pages that were updated with links
   - Confirm the push succeeded
