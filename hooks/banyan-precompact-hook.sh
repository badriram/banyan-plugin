#!/bin/bash
# BANYAN PRE-COMPACT HOOK — Emergency capture before context compaction
#
# Claude Code "PreCompact" hook. Fires RIGHT BEFORE the conversation
# gets compressed to free up context window space.
#
# This is the safety net. When compaction happens, the AI loses detailed
# context. This hook forces one final capture of everything important.
#
# Unlike the save hook (which triggers every N exchanges), this ALWAYS
# blocks — because compaction is always worth saving before.
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

echo "[$(date '+%H:%M:%S')] PRE-COMPACT triggered for session $SESSION_ID" >> "$STATE_DIR/hook.log"

cat << 'HOOKJSON'
{
  "decision": "block",
  "reason": "Context compaction imminent. Call banyan_capture immediately with a comprehensive summary of all uncaptured insights from this session: decisions made, findings discovered, open questions, and any work in progress. Include suggested trunk/branch targets for each capture. This is your last chance to save before context is compressed."
}
HOOKJSON
