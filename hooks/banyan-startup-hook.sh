#!/bin/bash
# BANYAN STARTUP HOOK — Prompt checkin on session start
#
# Claude Code "SessionStart" hook. Fires when a new session begins.
# Blocks and tells the AI to call banyan_checkin with session_start:true
# so the response includes the agent's persistent diary entries on this
# trunk (the Memento polaroid wall) — not just the single-string handoff
# from the previous session.

cat << 'HOOKJSON'
{
  "decision": "block",
  "reason": "New session. Call banyan_checkin with your agent_id (and optionally role + trunk_id) AND session_start:true to orient. The response includes: what changed since your last session, the previous session's handoff string, AND your diary entries on this trunk (last 20 — the persistent Memento polaroid wall for your (user, agent_id, trunk_id) cell, surviving across sessions). If you don't yet know which trunk you're on, run banyan_list_trunks first. Example: banyan_checkin({ agent_id: 'code-builder', role: 'code-builder', trunk_id: '<your-trunk-id>', session_start: true })"
}
HOOKJSON
