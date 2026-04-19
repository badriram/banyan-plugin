---
name: goal-discovery
description: Goal discovery and decomposition — use when the user wants to define a goal, plan work, or break down an objective into actionable items.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Goal Discovery Protocol

Guided conversation to decompose a goal into domains, key results, and work items. Write the result directly to Banyan.

## Leaf Type Schemas

### goal (plain text is preferred — structured JSON optional)
Plain text: "Ship the authentication system by Q3 with SSO support"
Structured (optional): {"title": "...", "description": "...", "timeline": "...", "metric": "...", "domains": [...], "temperature": "exploratory|balanced|disciplined"}

### kr (key result)
{"target": "description of target state", "current": "where we are now", "unit": "metric unit", "status": "not-started|on-track|at-risk|blocked"}

### work_item
{"description": "what needs to be done", "acceptance_criteria": "how to verify it's done", "assignee": "role or person", "status": "open|in-progress|done", "complexity": "simple|standard|complex"}

### decision
{"resolution": "what was decided", "context": "why this came up", "tradeoff": "what was traded off", "alternatives": ["rejected option 1", "rejected option 2"]}

### feasibility
{"judgment": "viable|risky|blocked", "physical": "...", "resource": "...", "timeline": "...", "dependency": "...", "recommendation": "..."}

## Connection Types for Goal Graph

### Downward (decomposition)
- **has_domain**: goal leaf → domain branch
- **has_outcome**: domain branch → KR leaf
- **requires_work**: KR leaf → work_item leaf

### Upward (signals)
- **drives**: work_item → KR (completion drives progress)
- **challenges**: leaf challenges an assumption in a parent
- **exposes_risk_to**: leaf exposes risk to a KR or goal
- **proposes_alternative_to**: alternative approach
- **reveals_opportunity_for**: new opportunity discovered

### Lateral
- **depends_on**: work_item → work_item

## Discovery Flow

1. **Elicit** — "What do you want to achieve?" Accept natural language.
2. **Clarify** — Ask 3-5 questions adapted to the goal. Don't ask generic questions if the user already provided detail.
3. **Structure** — Propose the decomposition. Show it before writing.
4. **Confirm** — User approves or adjusts.
5. **Write** — Create all nodes and connections in Banyan.
6. **Summarize** — List what was created with IDs.

## Example

User: "I want to ship our API to external developers"

**Goal**: "Ship public API for external developers by end of Q3"

**Domains** (branches):
- API Design
- Documentation
- Auth & Security
- Developer Experience

**KRs**:
- API Design: "OpenAPI spec published and versioned"
- Documentation: "Quickstart guide + 3 integration tutorials live"
- Auth: "OAuth2 flow with rate limiting deployed"
- DX: "3 beta partners successfully integrated"

**Work items**:
- "Design REST endpoint structure" → API Design
- "Build OAuth2 client credentials flow" → Auth
- "Write quickstart guide" → Documentation
- "Create developer portal landing page" → DX
