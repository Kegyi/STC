# AI Folder Usage Instructions
**For:** AI models participating in STC brainstorming sessions  
**Read this file once per session before doing anything else.**

---

## What This Folder Contains

| File/Folder | Role |
|---|---|
| `context_map.md` | **Tier 1 — always load.** Full STC concept compressed to ~150 lines. |
| `log_summary.md` | **Tier 1 — always load.** Cross-session history: decisions made, open threads. |
| `roadmap.md` | **Tier 1 — always load.** Living priority list of sections by work needed. Use to suggest focus topics and to update after sessions. |
| `sections/NN_topic.md` | **Tier 2 — load for session focus.** Compressed context map for one Reference Manual section: locked decisions, open questions, compliance notes, cross-refs. Created on demand. |
| `logs/YYYY-MM-DD.md` | **Load when resuming a specific day.** Full session log. |
| `logs/_template.md` | Template for new daily log. Do not inject. |
| `sections/_template.md` | Template for new section context map. Do not inject. |

---

## Session Start Protocol

**Step 1 — Load Tier 1 (always):**
Read `context_map.md` and `log_summary.md` before anything else.

**Step 2 — Identify focus:**
Ask the user (or infer from their opening message) what topic they want to brainstorm.  
If the user has **not stated a topic**, consult `roadmap.md` and suggest the top Critical-tier section that has not yet been brainstormed.

**Step 3 — Look up the Topic Registry (below) and load additional context:**
- Match the topic to a row in the registry
- If a **Tier 2** file is listed and exists → load it first (compressed, cheap)
- If the session needs the actual spec text → also load the **Tier 3** file
- If no Tier 2 file exists yet for the topic → load Tier 3 directly, and offer to create the Tier 2 context map at the end of the session

**Step 4 — Confirm focus and proceed.**

> **Running with file tools (VS Code Copilot agent):** Fetch the files autonomously using the file read tool — do not ask the user to paste them.  
> **Running without tools (plain chat):** Tell the user exactly which file paths to attach before proceeding.

Do **not** ask the user to re-explain the STC concept — it is in `context_map.md`.  
Do **not** load the full `v2026.1.0.md` — it is 2000+ lines. Use individual section files.

---

## Topic Registry

Match the user's topic to one or more rows. Load all matched files.

### Reference Manual Sections

| Topic keywords | Tier 2 `ai/sections/` | Tier 3 `docs/.../sections/` |
|---|---|---|
| logical/physical isolation, lego/clay, POD, decoupling | *(not yet)* | `01_foundational_paradigm_logical_vs_physical_isolation.md` |
| pillars, 5 pillars, execution physics, pipeline interceptors, infrastructure | *(not yet)* | `02_core_architectural_pillars.md` |
| principles, STC principles, subtractive physics, isomorphic, lifetime conservation, hermeticity, reactive physics, zero-intrusion | *(not yet)* | `03_core_compiler_principles.md` |
| compiler internals, clay AST, ECS IR, pass-DAG, STC-LSP, codegen, ingest, component schema, pass manifest, lifecycle, phase-gated mutation | `04_clay_ast.md` ✓ | `04_compiler_architecture_the_clay_ast.md` |
| YAML recipe, topology recipe, DSL, archetype, recipe schema, node/edge spec | *(not yet)* | `05_declarative_topology_recipe_specification_yaml.md` |
| hot-swap, live morphing, reconfiguration, strategy A, strategy B, dlopen, topology controller thread | `06_dynamic_reconfiguration.md` ✓ | `06_dynamic_reconfiguration_live_morphing_operations.md` |
| CDB, context database, cache, redis, valkey, caching layer, ZADD | *(not yet)* | `07_realtime_context_database_cdb_implementation.md` |
| PSA, persistent storage, database adapter, SQLite, PostgreSQL, MongoDB, ORM, monadic contract | *(not yet)* | `08_persistent_storage_adapter_psa_implementation.md` |
| compliance, ASIL, ASIL-D, MISRA, DO-178C, IEC 62304, safety, automotive safety, avionics | *(not yet)* | `09_conditional_compliance_framework.md` |
| memory model, lifetime, zero-copy, heap allocation, stack, data lifetime guarantee | *(not yet)* | `10_memory_model_data_lifetime_guarantees.md` |
| brick catalog, blueprint, redis-lite, kafka-lite, nginx-lite, infrastructure bricks | *(not yet)* | `11_modularity_the_brick_catalog.md` |
| transport, protocol bridge, gRPC, protobuf, SHM transport, DPDK, AF_XDP, communication taxonomy | *(not yet)* | `12_communication_transport_taxonomy_swapping.md` |
| compiler passes, pass specification, verifier, optimizer, WCET pass, fusion pass, pass-DAG executor | *(not yet)* | `13_compiler_pass_specification.md` |
| error reporting, diagnostics, fault contract, error types | *(not yet)* | `14_error_reporting_contract.md` |
| recipe schema formalization, YAML schema, schema validation, recipe grammar | *(not yet)* | `15_recipe_schema_formalization.md` |
| multi-language, polyglot, P4, SystemC, Rust, Python interop, language targets | *(not yet)* | `16_multilanguage_target_support.md` |
| topology extension, feature pack, decorator, plugin, feature integration | *(not yet)* | `17_topology_extension_feature_integration.md` |
| RCU, epoch-based reclamation, double-buffer routing, SHM sidecar, option 1/2/3, swap implementation, traps | `20_dynamic_swapping.md` ✓ | `20_dynamic_swapping_implementation_patterns.md` |

### Improvement Ideas & Proposals

| Topic keywords | File (no Tier 2 exists — load directly) |
|---|---|
| Roadmap overview, all 47 improvements, tier ranking, improvement summary | `docs/improvement_ideas/summary.md` |
| Core improvements 1–11, execution-physics morphing, backpressure, register allocation | `docs/improvement_ideas/part_1.md` … `part_4.md` |
| Telecom, 5G UPF, O-RAN, SmartNIC P4, RDMA, network slicing | `docs/improvement_ideas/part_5_telecom.md` |
| MedTech, IEC 62304, MPU/MMU isolation, isochronous sync, fail-operational | `docs/improvement_ideas/part_6_MedTech.md` |
| Robotics, ROS2, rate-monotonic, DDS-bypass, kinematic transform, E-stop | `docs/improvement_ideas/part_7_Robotics.md` |
| Gaming, ECS data flow, rollback netcode, spatial replication, fixed-point math | `docs/improvement_ideas/part_8_Gaming.md` |
| IoT, embedded, sleep morphing, header-only, flash storage, bootloader | `docs/improvement_ideas/part_9_IoT.md` |
| Cloud SaaS, tenant isolation, SIMD JSON, two-tier cache, CRIU checkpoint | `docs/improvement_ideas/part_10_Cloud_SaaS.md` |
| Aerospace, DO-178C, WCET scheduling, diverse-path TMR, SECDED, ARINC 653 | `docs/improvement_ideas/part_11_Aerospace.md` |
| HFT, FinTech, trading, matching engine, NVMe journaling, PII sanitization | `docs/improvement_ideas/part_12_FinTech_HFT.md` |
| Compiler meta-improvements, pluggable backend, pass DLLs, ECS AST upgrade | `docs/improvement_ideas/STC_compiler.md` |
| Smart home, Home Assistant, IoT hub, multi-target partition, delta streaming | `docs/improvement_ideas/based_on_home_asistant_topic.md` |
| State transfusion, recipe-driven strategy, formal verification loop, swap upgrades | `docs/improvement_ideas/dynamic_swapping_proposals.md` |

> **Tier 2 files marked ✓ exist.** All others marked *(not yet)* will be created after the first brainstorm session on that topic.

---

## Session End Protocol

### When to initiate

Propose a session wrap-up when **any** of these conditions are true:
- A concrete decision was reached (something is now "locked")
- A gap was closed or a new gap was discovered
- The user says they are done, or the conversation has reached a natural conclusion
- The session has produced at least one thing worth preserving — even a single new open question counts

Do **not** wait for the user to ask. When the trigger fires, say:

> "We've reached a good stopping point. I'll prepare the session updates — give me a moment."

Then immediately draft all four updates (see below). Present them to the user for confirmation before writing anything.

---

### What to update

| File | What to do |
|---|---|
| `logs/YYYY-MM-DD.md` | Append a new session block (copy structure from existing blocks in the file; create the file from `_template.md` if today has no log yet) |
| `log_summary.md` | Add new decisions to the Decisions Log table; update Open Threads if any were opened or closed |
| `ai/sections/NN_topic.md` | Create from `sections/_template.md` if first session on this section; otherwise update — move open questions to locked decisions if resolved, add newly discovered gaps |
| `roadmap.md` | Reduce work estimate if gaps were closed; add newly discovered gaps; re-rank if a dependency resolved; append a row to the Change Log |

---

### Write-capable model (VS Code Copilot)

1. Draft all four updates in the chat for the user to review
2. Ask: **"Shall I apply these changes?"**
3. On confirmation — write the files directly using file tools
4. Commit and push: `git add -A ; git commit -m "Session log YYYY-MM-DD: [topic]" ; git push`

---

### Read-only model (ChatGPT, Claude.ai, Gemini, etc.)

1. Draft all four updates in the chat
2. Present each as a clearly labelled, copy-pasteable block:

```
─── UPDATE: ai/logs/2026-06-27.md ─── APPEND TO END ───────────────────
### Session [N] — [Topic]
[full session block content]
────────────────────────────────────────────────────────────────────────

─── UPDATE: ai/log_summary.md ─── ADD TO DECISIONS TABLE ───────────────
| YYYY-MM-DD | [decision text] |
────────────────────────────────────────────────────────────────────────

─── UPDATE: ai/sections/NN_topic.md ─── [CREATE / REPLACE SECTION] ─────
[full file content or specific section to replace]
────────────────────────────────────────────────────────────────────────

─── UPDATE: ai/roadmap.md ─── REPLACE ROW + APPEND CHANGE LOG ──────────
[specific row or change log entry]
────────────────────────────────────────────────────────────────────────
```

3. Tell the user: **"Copy each block above into the corresponding file, then commit and push."**

---

## Brainstorming Guidelines

- **Stay narrow.** One topic per session produces better results than broad exploration.
- **Challenge assumptions.** The STC concept is still evolving — push back on ideas that conflict with the core principles.
- **Reference the principles by name** (e.g., "this violates the Subtractive Physics Synthesis principle because…").
- **Flag compliance implications** when discussing execution patterns — always note if something would be banned under MISRA/ASIL-D/DO-178C.
- **Conclude with actionable output**: a design decision, a new open question, or a concrete next step — not just observations.

---

## Fetching Files via URL (Web-Capable Models)

All files are publicly available at: `https://github.com/Kegyi/STC`

Raw file URL pattern:
```
https://raw.githubusercontent.com/Kegyi/STC/master/<path>
```

**Tier 1 — always fetch:**
```
https://raw.githubusercontent.com/Kegyi/STC/master/ai/context_map.md
https://raw.githubusercontent.com/Kegyi/STC/master/ai/log_summary.md
https://raw.githubusercontent.com/Kegyi/STC/master/ai/roadmap.md
```

**Tier 2 — section context maps (fetch by topic):**
```
https://raw.githubusercontent.com/Kegyi/STC/master/ai/sections/06_dynamic_reconfiguration.md
https://raw.githubusercontent.com/Kegyi/STC/master/ai/sections/20_dynamic_swapping.md
```

**Tier 3 — full section spec files:**
```
https://raw.githubusercontent.com/Kegyi/STC/master/docs/STC%20Co-Pilot%20%26%20Systems%20Architect%20Reference%20Manual/sections/NN_topic.md
```

Replace `NN_topic` with the section filename (e.g., `06_dynamic_reconfiguration_live_morphing_operations.md`).  
Spaces in the path are encoded as `%20`, `&` as `%26`.

