# STC Log Summary
**Purpose:** Compressed cross-session memory — inject this alongside `context_map.md` at the start of every session.  
**Last updated:** 2026-06-25

---

## Current State of the Concept

- STC is fully defined at the architectural level (5 Pillars, 7 Principles, Compiler Architecture, YAML Recipe)
- The reference documentation is complete as of v2026.1.0
- No changes to the core concept have been made yet — all sessions so far have been meta/workflow setup
- Three concrete open directions are identified for future development (see below)

---

## Established Workflows

- **AI session workflow:** Inject `context_map.md` + `log_summary.md` → narrow focus → deep-dive section if needed → log conclusions
- **Document structure:** Big reference manual split into `sections/NN_topic.md` files; scripts in `scripts/` reassemble them
- **Logging:** One file per day in `ai/logs/YYYY-MM-DD.md`; this summary stays compressed for cheap injection

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
