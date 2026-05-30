---
description: Check in with Banyan — declare your role, see what changed, get your tasks, read your diary.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Call `banyan_checkin` with your agent_id, and optionally role + trunk_id. This orients you on the current state of the trunk you're working on. If you don't know your trunk_id yet, run `banyan_list_trunks` first to discover the trunks you have access to.

Example: `banyan_checkin({ agent_id: "code-builder", role: "code-builder", trunk_id: "<your-trunk-id>", session_start: true })`

**Diary discipline:** `banyan_checkin` is also where you write to your persistent per-trunk diary — append-only notes scoped to your `(user, agent_id, trunk_id)` cell, surviving across sessions.

- **First checkin of a new session?** Pass `session_start: true` to receive your last 20 diary entries in the response.
- **Mid-session moments worth remembering?** Pass `diary_entry: "..."` — appends one entry (≤4KB). Use this for decisions, blockers, checkpoints. Survives across sessions.
- **End of session / pre-compaction?** Pass `handoff: "..."` — single-string overwriteable summary that surfaces first on next checkin.
- **See `diary_hint` in the response?** It means you haven't tattooed anything in 24h on this trunk. Take 30 seconds.

`depth: 0` = quick ~200 token summary, `depth: 1` (default) = standard context, `depth: 2` = full response.
