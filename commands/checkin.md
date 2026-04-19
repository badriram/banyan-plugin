---
description: Check in with Banyan — declare your role, see what changed, get your tasks.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Call `banyan_checkin` with your agent_id, role, and trunk_id. This orients you on the current state of the trunk you're working on.

Example: `banyan_checkin({ agent_id: "code-builder", role: "code-builder", trunk_id: "bnyn-927d9c72" })`

Use `depth: 0` for a quick ~200 token summary, `depth: 1` (default) for standard context, or `depth: 2` for the full response with schemas and thread content.
