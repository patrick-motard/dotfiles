---
description: Review recent work and recommend automation
---

Analyze the recent conversation to identify if a workflow should be automated as a skill, command, agent, or documentation.

Steps:

1. **Summarize the recent work:**
   - Review the last 10-20 messages in the conversation
   - Identify the complex task or workflow that was performed
   - Extract the key steps, tools used, and decisions made
   - Note any repeated patterns or manual processes

2. **Analyze automation potential:**
   - Is this a repeatable pattern?
   - How frequently would this be used?
   - What's the complexity level?
   - Does it require multi-step coordination?
   - Would automation save significant time/tokens?

3. **Present options to user:**
   Ask the user to select the appropriate automation type:

   **Options:**
   - **Slash Command**: Explicit prompt expansion, user-triggered, simple-to-moderate complexity
   - **Skill**: Model-invoked capability, Claude decides when to use it, focused expertise
   - **Agent**: Complex task needing dedicated context window and specialized tools
   - **CLAUDE.md**: Documentation/guidelines that should be in project or global CLAUDE.md
   - **None**: Not worth automating, one-off task

4. **For each option, explain:**
   - **Why this type fits** (or doesn't fit)
   - **Trade-offs** (e.g., slash commands require manual trigger, skills are auto-invoked)
   - **Suggested name** and structure
   - **Key components** that would be included

5. **After user selects type, ask scope:**
   - **Current project only** (`.claude/commands/`, `.claude/skills/`, `.claude/agents/` in current repo)
   - **Global** (`~/.claude/commands/`, `~/.claude/skills/`, `~/.claude/agents/`)
   - **Both** (create globally and optionally override in project)

6. **If CLAUDE.md selected, ask:**
   - **Project CLAUDE.md** (current repo only)
   - **Global CLAUDE.md** (`~/.claude/CLAUDE.md` - applies to all projects)
   - **Both** (global guidelines with project-specific overrides)

7. **Create the automation:**
   - Generate the appropriate file structure
   - Include clear documentation
   - Add examples where relevant
   - Follow best practices from Claude Code docs
   - For slash commands: use proper frontmatter and clear steps
   - For skills: include description, instructions, and examples
   - For agents: include system prompt, tool access, and usage guidance
   - For CLAUDE.md: structure as clear guidelines with context

8. **Confirm and show:**
   - Display the file path created
   - Show the content
   - Explain how to use/invoke it
   - Mention any next steps (e.g., testing, iteration)

**Important considerations:**
- Slash commands are great for explicit, frequently-used prompts
- Skills should be focused on one capability and model-invoked
- Agents need dedicated context - use sparingly
- CLAUDE.md is for persistent context/guidelines that should always be loaded
- Consider token costs: CLAUDE.md loads every conversation, commands/skills load on-demand
