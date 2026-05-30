#!/bin/bash
# BANYAN PRE-COMPACT HOOK — Last-gasp capture before context compaction
#
# Claude Code "PreCompact" hook. Fires RIGHT BEFORE the conversation
# gets compressed to free up context window space.
#
# This is the safety net. The forced checkin writes BOTH:
#   - diary_entry: a permanent append-only note for the (user, agent_id,
#     trunk_id) cell capturing the specific WIP about to be lost.
#   - handoff:     the single-string overwriteable summary that
#     surfaces on next session's checkin response.
#
# Why both: the diary preserves the moment (decisions, blockers, the
# "why" behind shipped code) — accumulates across sessions. The
# handoff is the at-a-glance summary surfaced first on next checkin
# regardless of session_start. Compaction is the right time to write
# both; for mid-session save-hook fires the script writes diary_entry
# only.
#
# Unlike the save hook (which triggers every N exchanges), this ALWAYS
# blocks — compaction is always worth saving before.
#
# Adapted from MemPalace's mempal_precompact_hook.sh (MIT License, 2026 MemPalace Contributors)
#
# === INSTALL ===
# Add to .claude/settings.local.json:
#
#   "hooks": {
#     "PreCompact": [{
#       "hooks": [{
#         "type": "command",
#         "command": "/absolute/path/to/banyan-precompact-hook.sh",
#         "timeout": 30
#       }]
#     }]
#   }

STATE_DIR="$HOME/.banyan/hook_state"
mkdir -p "$STATE_DIR"

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id','unknown'))" 2>/dev/null)

# One-shot block per session: first /compact attempt forces a checkin
# with diary_entry + handoff, subsequent attempts pass through. Without
# this gate the user gets stuck — /compact blocks → checkin happens →
# user retries → blocks again forever.
MARKER="$STATE_DIR/${SESSION_ID}_precompact_warned"

if [ -f "$MARKER" ]; then
    echo "[$(date '+%H:%M:%S')] PRE-COMPACT pass-through for session $SESSION_ID (already warned)" >> "$STATE_DIR/hook.log"
    echo "{}"
    exit 0
fi

touch "$MARKER"
echo "[$(date '+%H:%M:%S')] PRE-COMPACT first-block for session $SESSION_ID" >> "$STATE_DIR/hook.log"

cat << 'HOOKJSON'
{
  "decision": "block",
  "reason": "Context compaction imminent. Call banyan_checkin NOW with agent_id + trunk_id + BOTH: (1) diary_entry capturing the specific WIP about to be lost — the moment-level facts (a decision, a blocker, the why behind the code that just shipped) that compaction will eat; (2) handoff with the at-a-glance summary that surfaces on the very next checkin (what shipped, what's blocked, what to do first). The diary entry is append-only and resurfaces on next session_start; handoff overwrites but is the first thing future-you sees. Example: banyan_checkin({ agent_id: 'code-builder', trunk_id: '<your-current-trunk>', diary_entry: 'Pre-compact moment: about to merge RRULE recurrence PR. EXDATE TZ-normalization scoped to recurrence path only. e2e green on staging.', handoff: 'RRULE work_item recurrence shipping. Staging green. PR ready. Frontend RecurrencePicker.tsx + backend recurrence.go + leaf schema RRULE/DTSTART/EXDATE. Next: prod deploy.' }). This is your last chance before compaction. After your checkin completes, tell the user that /compact can be retried — this hook lets the second attempt through (the hook itself does not retry automatically)."
}
HOOKJSON
