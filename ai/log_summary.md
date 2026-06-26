# STC Log Summary
**Purpose:** Compressed cross-session memory — inject this alongside `context_map.md` at the start of every session.  
**Last updated:** 2026-06-26

---

## Current State of the Concept

- STC is fully defined at the architectural level (5 Pillars, 7 Principles, Compiler Architecture, YAML Recipe)
- The reference documentation is complete as of v2026.1.0; Section 20 (Dynamic Swapping Implementation Patterns) added 2026-06-26
- No changes to the core STC concept yet — all sessions to date have been infrastructure/workflow setup
- Three concrete open directions identified for future development (see below)
- Workspace is published at **https://github.com/Kegyi/STC** (public)

---

## Established Workflows

- **AI session workflow (three-tier):** Always load Tier 1 (`context_map.md` + `log_summary.md`) → state topic → model looks up Topic Registry in `INSTRUCTIONS.md` → auto-fetches Tier 2 (section context map) and/or Tier 3 (full spec file) as needed
- **Web AI start:** Paste 3 raw GitHub URLs (`INSTRUCTIONS.md`, `context_map.md`, `log_summary.md`) → state topic → model fetches the rest
- **Document structure:** Reference Manual split into `sections/NN_topic.md`; `ai/sections/` holds compressed context maps for brainstormed sections
- **Logging:** One file per day in `ai/logs/YYYY-MM-DD.md`; this summary stays compressed for cheap injection
- **Repo:** All files publicly accessible at `https://raw.githubusercontent.com/Kegyi/STC/master/<path>`

---

## Open Threads (prioritized)

1. **Direction A — Schema-Driven Introspection**  
   After compiler fusion, the logical graph is lost. Need a companion Introspection Schema so debuggers can map register states back to YAML nodes without production overhead.

2. **Direction B — Topological Conflict Resolution Solver**  
   Conflicting execution profiles on connected nodes (e.g., Interrupt-Driven + Thread-per-Core) need a mid-compiler CSP solver that auto-injects adapter nodes.

3. **Direction C — Distributed Multi-Node Orchestration**  
   Extend the compiler to partition a unified logical graph across multiple physical cluster nodes at compile time, bypassing container orchestration layers.

---

## Decisions Log (newest first)

| Date | Decision |
|---|---|
| 2026-06-25 | Adopted `ai/` folder for all AI-session files; daily log files under `ai/logs/` |
| 2026-06-25 | Reference Manual (2292 lines) split into 20 section files in `sections/` — original kept intact |
| 2026-06-25 | `context_map.md` established as the always-on context file (~150 lines) |
| 2026-06-25 | Brainstorming workflow: map + summary at start; section files on demand; log after |
| 2026-06-25 | `scripts/assemble_docs.ps1` created to reassemble Reference Manual from sections |
| 2026-06-26 | Deleted 3 redundant docs (STC.md, STX_principles.md, Introduction_to_STC.md) — fully covered by Reference Manual |
| 2026-06-26 | `dynamic_swapping.md` promoted to Reference Manual Section 20; `dynamic_swapping_usage.md` moved to `improvement_ideas/dynamic_swapping_proposals.md` |
| 2026-06-26 | Three-tier context model established; `ai/sections/` folder created with template and first two context maps (06, 20) |
| 2026-06-26 | Topic Registry added to `INSTRUCTIONS.md` — model auto-selects files based on stated topic |
| 2026-06-26 | Repo published: https://github.com/Kegyi/STC (public); raw URL pattern documented in INSTRUCTIONS.md and README |
