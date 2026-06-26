# System-Topology Compiler (STC) — Workspace Guide

**Repository:** https://github.com/Kegyi/STC  
**Raw file base URL:** `https://raw.githubusercontent.com/Kegyi/STC/master/`

This workspace contains the design documentation and brainstorming infrastructure for the **STC concept** — a declarative compilation framework that transforms software architecture into optimized, distributed binaries by fully decoupling business logic from execution infrastructure.

---

## What Is STC? (30-Second Version)

You write pure domain logic as C++ POD structs ("Lego Bricks"). A YAML recipe defines where and how it runs ("Clay"). The STC compiler weaves them together — synthesizing thread models, network bindings, CI/CD pipelines, and compliance checks — without touching the business logic. Swap the YAML, get a different binary: bare-metal automotive, HFT engine, 5G gateway, or Kubernetes service.

---

## Folder Structure

```
STC/
├── README.md                          ← you are here
│
├── ai/                                ← AI brainstorming session files
│   ├── INSTRUCTIONS.md                   how the AI folder works (read this first)
│   ├── context_map.md                    compressed concept map — always inject (Tier 1)
│   ├── log_summary.md                    compressed session history — always inject (Tier 1)
│   ├── logs/
│   │   ├── _template.md                  copy this for each new day
│   │   └── YYYY-MM-DD.md                 daily session logs
│   └── sections/                         section-level context maps — inject for focus area (Tier 2)
│       ├── _template.md                  copy this when brainstorming a new section for the first time
│       ├── 06_dynamic_reconfiguration.md
│       └── 20_dynamic_swapping.md
│
├── docs/                              ← all source documentation
│   ├── STC Architectural Core Reference/
│   │   └── v2026.1.0.md                  detailed pillar specs, CDB/PSA, memory model
│   │
│   ├── STC Co-Pilot & Systems Architect Reference Manual/
│   │   ├── v2026.1.0.md                  full combined reference — do NOT inject whole file
│   │   └── sections/                     20 individual topic files (inject one at a time — Tier 3)
│   │       ├── 01_foundational_paradigm_logical_vs_physical_isolation.md
│   │       ├── 02_core_architectural_pillars.md
│   │       ├── 03_core_compiler_principles.md
│   │       ├── 04_compiler_architecture_the_clay_ast.md
│   │       ├── 05_declarative_topology_recipe_specification_yaml.md
│   │       ├── 06_dynamic_reconfiguration_live_morphing_operations.md
│   │       ├── 07_realtime_context_database_cdb_implementation.md
│   │       ├── 08_persistent_storage_adapter_psa_implementation.md
│   │       ├── 09_conditional_compliance_framework.md
│   │       ├── 10_memory_model_data_lifetime_guarantees.md
│   │       ├── 11_modularity_the_brick_catalog.md
│   │       ├── 12_communication_transport_taxonomy_swapping.md
│   │       ├── 13_compiler_pass_specification.md
│   │       ├── 14_error_reporting_contract.md
│   │       ├── 15_recipe_schema_formalization.md
│   │       ├── 16_multilanguage_target_support.md
│   │       ├── 17_topology_extension_feature_integration.md
│   │       ├── 18_references.md
│   │       ├── 19_legend.md
│   │       └── 20_dynamic_swapping_implementation_patterns.md
│   │
│   └── improvement_ideas/             future enhancement proposals (not current spec)
│       ├── summary.md                    overview + production likelihood ranking (47 improvements)
│       ├── part_1.md … part_4.md         core architectural improvements
│       ├── part_5_telecom.md             5G / O-RAN domain
│       ├── part_6_MedTech.md             IEC 62304 / medical domain
│       ├── part_7_Robotics.md            ROS2 / real-time robotics
│       ├── part_8_Gaming.md              game engine patterns
│       ├── part_9_IoT.md                 embedded / battery-constrained
│       ├── part_10_Cloud_SaaS.md         cloud infrastructure
│       ├── part_11_Aerospace.md          DO-178C / avionics
│       ├── part_12_FinTech_HFT.md        high-frequency trading
│       ├── STC_compiler.md               compiler self-architecture improvements
│       ├── based_on_home_asistant_topic.md  smart-home / IoT use case
│       └── dynamic_swapping_proposals.md    3 compiler upgrades for hot-swap (state transfusion, recipe-driven strategy, formal verification)
│
└── scripts/
    ├── split_reference_manual.ps1     splits v2026.1.0.md into sections/ (re-run after editing the big file)
    └── assemble_docs.ps1              stitches sections/ back into one readable file
```

---

## How to Start a Brainstorming Session

### Three-Tier Context Model

| Tier | Files | When |
|---|---|---|
| **Tier 1 — Always** | `ai/context_map.md` + `ai/log_summary.md` | Every session |
| **Tier 2 — Focus** | `ai/sections/NN_topic.md` | Compressed context for the target section |
| **Tier 3 — Deep dive** | `docs/.../sections/NN_topic.md` | Full spec text when needed |

The model selects Tier 2/3 files **automatically** based on your stated topic using the Topic Registry in `ai/INSTRUCTIONS.md`. In VS Code Copilot it fetches them using file tools; in a plain chat it tells you exactly which files to attach.

> **Never paste the full `v2026.1.0.md`** into a chat. It is 2000+ lines. Use individual section files.

---

### Session Prompt Examples

#### 1. New session — state your topic, let the model handle context loading
```
I've attached ai/INSTRUCTIONS.md, ai/context_map.md, and ai/log_summary.md.

Topic: I want to brainstorm how to make the hot-swap strategy selection
(Option 1 / 2 / 3) recipe-driven rather than a manual implementation choice.
```
*The model matches "hot-swap / strategy" in the Topic Registry, loads `ai/sections/06_dynamic_reconfiguration.md` and `ai/sections/20_dynamic_swapping.md` automatically, then proceeds.*

---

#### 2. Domain expansion
```
I've attached ai/INSTRUCTIONS.md, ai/context_map.md, and ai/log_summary.md.

Topic: Evaluate the 4 aerospace improvements and pick the most feasible one
to spec out as a new Reference Manual section.
```
*Model matches "aerospace / DO-178C" → loads `improvement_ideas/part_11_Aerospace.md`.*

---

#### 3. Resuming from a previous session
```
I've attached ai/INSTRUCTIONS.md, ai/context_map.md, ai/log_summary.md,
and ai/logs/2026-06-26.md.

Resume from yesterday — pick up the open question on Direction B.
```

---

#### 4. First time on a section with no Tier 2 context yet
```
I've attached ai/INSTRUCTIONS.md, ai/context_map.md, and ai/log_summary.md.

Topic: Deep dive into the Conditional Compliance Framework (Section 09).
Find gaps and flag open questions.
```
*Model finds no Tier 2 file for section 09, loads Tier 3 directly, and offers to draft the `ai/sections/09_conditional_compliance.md` context map at the end.*

---

## After Each Session

1. Open or create `ai/logs/YYYY-MM-DD.md` (copy `_template.md` if it's a new day)
2. Fill in the session block — conclusions, decisions, open questions
3. Update `ai/log_summary.md` — add decisions to the table, update open threads
4. Create or update `ai/sections/NN_topic.md` — lock in any decisions made, update open questions

> The AI model can draft all four of these updates at the end of a session if you ask it to.

---

## Scripts

Run from the workspace root (`c:\Users\Kegyi\STC`):

```powershell
# Reassemble the full Reference Manual into one readable file
powershell -ExecutionPolicy Bypass -File scripts\assemble_docs.ps1

# Re-split after editing v2026.1.0.md directly
powershell -ExecutionPolicy Bypass -File scripts\split_reference_manual.ps1
```

The assembler generates the header and Table of Contents dynamically — no manual maintenance needed. Any new section file named `NN_*.md` dropped into `sections/` will be picked up automatically on the next assemble run.

