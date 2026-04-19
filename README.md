# Banyan Claude Code Plugin

> **Source of truth** for plugin development. Distribution copies are generated into `web/public/plugins/banyan/` and deployed to `https://banyan.vamitra.com/plugins/` via S3 + CloudFront.

Collaborative knowledge graph for teams and AI agents. This plugin provides:

- **37 MCP tools** for reading, writing, and navigating the knowledge graph
- **Auto-capture hooks** that save session insights before they're lost
- **Slash commands** for quick access to common operations

## Installation

1. Install the plugin in Claude Code (when plugin marketplace is available)
2. Authenticate with your Banyan account via OAuth
3. The plugin auto-registers the MCP server and hooks

## Manual Setup

Add to your `.mcp.json`:

```json
{
  "mcpServers": {
    "banyan": {
      "type": "url",
      "url": "https://mcp.banyan.sh/mcp"
    }
  }
}
```

To enable auto-capture hooks, add to `.claude/settings.local.json`:

```json
{
  "hooks": {
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "bash /path/to/.claude-plugin/hooks/banyan-save-hook.sh",
        "timeout": 30
      }]
    }],
    "PreCompact": [{
      "hooks": [{
        "type": "command",
        "command": "bash /path/to/.claude-plugin/hooks/banyan-precompact-hook.sh",
        "timeout": 30
      }]
    }]
  }
}
```

## Commands

- `/banyan:checkin` — Check in with Banyan, get context for your session
- `/banyan:capture` — Save insights from this conversation
- `/banyan:status` — Overview of your knowledge graph

## Hooks

- **Save Hook** (Stop event): Every 10 human messages, prompts the AI to call `banyan_capture` with session insights. Captures go to your inbox as drafts for human review.
- **Pre-Compact Hook** (PreCompact event): Before context window compression, forces an emergency capture of all uncaptured insights.

Both hooks preserve Banyan's deliberate authorship model — nothing is auto-promoted to the graph. You review and promote captures from your inbox.
