# Section 20 — Dynamic Swapping: Implementation Patterns
**Reference file:** `docs/STC Co-Pilot & Systems Architect Reference Manual/sections/20_dynamic_swapping_implementation_patterns.md`
**Last updated:** 2026-06-26

---

## What This Section Specifies
Implementation-level detail for Strategy A (Section 06). Defines 3 concrete hot-swap execution options with C++ code, a trap catalogue for naïve approaches, and an architectural trade-off table comparing latency, memory, ABI rigidity, and safety risk across the 3 options.

---

## Locked Decisions
- **Option 1 (RCU Atomic Pointer Swap):** C-style flat ABI + epoch-based reclamation; ~2ns hot-path overhead; best latency but delays `dlclose` until all epoch counters are even
- **Option 2 (Double-Buffer Routing):** Duplicate graph path; atomic `active_path` switch; zero memory hazards but doubles memory footprint during transition
- **Option 3 (SHM Sidecar):** Out-of-process via lock-free shared memory ring; crash-isolated; zero ABI constraints; but 100ns–1µs IPC overhead
- Four traps are formally catalogued: mutex contention, use-after-free on `dlclose`, VMT ABI mismatch, MISRA violation from `dlopen`

---

## Open Questions / Tensions
- No mechanism yet to select option 1/2/3 from the YAML recipe — selection is manual at implementation time (Upgrade 1 in `improvement_ideas/dynamic_swapping_proposals.md`)
- Option 3 IPC overhead may be acceptable for Cloud SaaS targets but blocks HFT/Automotive use — formal profiling not done
- None of the 3 options addresses state continuity (running totals, sliding windows) across the swap boundary

---

## Compliance Implications
- All 3 options involve `dlopen` and are therefore **non-compliant** under MISRA-C++ 2023 / ASIL-D — only valid under Strategy A (CloudSaaS / low-latency non-safety profiles)
- Option 2 is the safest of the three for near-safety contexts due to path isolation, but still uses `dlopen`

---

## Cross-References
- **Section 06** — High-level Strategy A / Strategy B definition; this section is a direct extension
- **Section 09** — Compliance framework that gates which profiles may use Strategy A at all
- **`improvement_ideas/dynamic_swapping_proposals.md`** — 3 compiler upgrade proposals that build on top of this section: recipe-driven selection (Upgrade 1), POD state transfusion (Upgrade 2), formal verification loop (Upgrade 3)
