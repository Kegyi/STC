# Section 06 — Dynamic Reconfiguration & Live Morphing Operations
**Reference file:** `docs/STC Co-Pilot & Systems Architect Reference Manual/sections/06_dynamic_reconfiguration_live_morphing_operations.md`
**Last updated:** 2026-06-26

---

## What This Section Specifies
Defines the two compiler-level strategies for handling topology changes at runtime. Strategy A (Hot-Swap) injects a Topology Controller Thread and uses `dlopen`/`dlclose` to swap modules without dropping packets. Strategy B (Static Fusion) bakes the graph into a static binary — no live morphing, maximum performance, required for safety-critical targets.

---

## Locked Decisions
- Strategy B is **mandatory** for ASIL-D, DO-178C, and MISRA-C++ profiles — `dlopen` is a safety violation in those contexts
- Strategy A's hot-swap sequence is 4 steps: load → drain → atomic pointer switch → reclaim
- The choice between Strategy A and B is declared in the YAML recipe profile, not in application code

---

## Open Questions / Tensions
- Which of the 3 implementation-level options (RCU / Double-Buffer / SHM) to use under Strategy A is **not yet recipe-driven** — currently a manual decision (see Section 20 and `improvement_ideas/dynamic_swapping_proposals.md` Upgrade 1)
- State continuity during hot-swap is unresolved — swapping a module that holds running aggregates or sliding windows will lose state (see `improvement_ideas/dynamic_swapping_proposals.md` Upgrade 2)

---

## Compliance Implications
- `dlopen` / `dlclose` violate MISRA-C++ 2023 — Strategy A must be disabled or flagged in safety profiles
- Strategy B produces WCET-provable execution paths; Strategy A cannot be formally bounded due to `dlopen` timing variability

---

## Cross-References
- **Section 20** — Implementation-level detail for all 3 Strategy A execution options (RCU, Double-Buffer, SHM)
- **Section 09** — Conditional Compliance Framework that determines when Strategy B is enforced
- **`improvement_ideas/dynamic_swapping_proposals.md`** — 3 proposed compiler upgrades: recipe-driven strategy selection, state transfusion, formal verification loop
