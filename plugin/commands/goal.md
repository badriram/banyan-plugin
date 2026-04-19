---
description: Define a goal and decompose it into domains, key results, and work items through guided conversation.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Guide the user through goal discovery using Socratic questioning. Follow this flow:

1. **Ask for the goal**: "What do you want to achieve?" Accept plain text — don't ask for JSON.

2. **Ask clarifying questions** (one round, 3-5 questions adapted to context):
   - What domains/areas does this span?
   - How will you know it's done? (measurable outcome)
   - What's the timeline?
   - What could break this? (risks/assumptions)
   - What resources or constraints exist?

3. **Propose structure** — show the user what you'll create:
   - Goal leaf (plain text description + metric + timeline)
   - Domain branches (1-4 areas)
   - KR leaves per domain (measurable key results)
   - Work item leaves (concrete tasks)
   Ask: "Does this structure look right? Anything to add or change?"

4. **Write to Banyan** — after user confirms:
   - Ask which trunk to target (or create a new one)
   - `banyan_add_leaf` with type "goal" — plain text content is fine
   - `banyan_grow_branch` for each domain
   - `banyan_add_leaf` with type "kr" under each domain branch
   - `banyan_add_leaf` with type "work_item" under KRs
   - `banyan_connect` goal to domains (relationship: "has_domain")
   - `banyan_connect` domains to KRs (relationship: "has_outcome")

5. **Summarize** what was created with node IDs.

Always set `agent_id`. Use `banyan_search` with scope to check for existing related content first.
