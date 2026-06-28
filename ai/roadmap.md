# STC Brainstorming Roadmap
**Purpose:** Living priority list for concept development sessions. Always inject alongside `context_map.md` and `log_summary.md`.  
**Last updated:** 2026-06-28  
**How to update:** After a session that changes a section's state, update the row — change work estimate, move it up/down, or add a note. Major priority shifts should also be recorded in `log_summary.md`.

---

## How the AI model should use this

- If the user **has not stated a topic**: suggest the top 1–2 items from the Critical tier as the session focus.
- If the user **has stated a topic**: check the roadmap entry for that section to load its known gaps before brainstorming.
- After a session: update the relevant row — reduce work estimate if gaps were closed, add new gaps if discovered, re-rank if a dependency was resolved.

---

## Priority Table

### 🔴 Critical — Blocking (must be done first)

| # | Section | Work | Key gap |
|---|---|---|---|
| **1** | **10 — Memory Model** | HIGH | Lease lifetime unformalized — no DAG-based calculation algorithm, no violation detection. Blocks P14–P17 synthesis passes. |
| **2** | **13 — Compiler Passes** | HIGH | Parallel stage execution model and error recovery flow unspecified. (ECS interaction contract resolved via §04 brainstorm 2026-06-28.) |
| **3** | **09 — Compliance Framework** | HIGH | Profiles listed but not defined. No composition/override rules, no audit artifact schemas. Blocks P9 verifier pass. |

### 🟠 High — Foundational, underspecified

| # | Section | Work | Key gap |
|---|---|---|---|
| **4** | **04 — Clay AST** | LOW-MED | Core decisions locked (component schema, query semantics, lifecycle). Four follow-on items: phase enforcement mechanism, pass manifest schema (→ §15), parallel scheduler design within a phase, component removal semantics. |
| **5** | **01 — Foundational Paradigm** | MED-HIGH | Lego/Clay split is intuitive but not formally bounded. No per-profile mapping rules. No fallback if isolation cannot be maintained. |
| **6** | **12 — Transport Taxonomy** | MED-HIGH | Layer 0 calling convention unspecified. SLA breach detection undefined. Bridge auto-generation algorithm incomplete. |
| **7** | **16 — Multi-Language** | MED-HIGH | Bridge implementation templates missing. ABI compatibility checking unspecified. Cross-language type conversion edge cases undefined. |
| **8** | **05 — Recipe Specification** | MEDIUM | Profile overlay merge semantics unformalized. Wildcard binding expansion incomplete. Validation interdependencies not in §15. |

### 🟡 Medium — Important, operational gaps

| # | Section | Work | Key gap |
|---|---|---|---|
| **9** | **06 — Dynamic Reconfiguration** | MEDIUM | RCU epoch management unspecified. Error conditions during hot-swap undefined. State transference for stateful nodes missing. |
| **10** | **07 — CDB** | MEDIUM | Error handling, reconnection, timeout semantics, and `CdbResult` thread safety all missing. |
| **11** | **08 — PSA** | MEDIUM | Transaction semantics undefined. No schema evolution strategy. Connection lifecycle unspecified. |
| **12** | **03 — Compiler Principles** | MEDIUM | No concrete C++ violation examples, no conflict resolution rules, no compiler-verification procedures per principle. |

### 🟢 Low — Well-specified, polish only

| # | Section | Work | Key gap |
|---|---|---|---|
| **13** | **02 — Architectural Pillars** | LOW | Needs inter-pillar interaction rules and compiler enforcement of boundary violations. |
| **14** | **11 — Brick Catalog** | LOW | Needs validation checklist per brick level and bundle recursion/circular-dependency limits. |
| **15** | **17 — Extension & Integration** | LOW | Needs error recovery on `dlopen` fail and incremental compilation caching strategy. |
| **16** | **14 — Error Reporting** | LOW | Needs error suppression/filtering rules and ordering/priority policy. |
| **17** | **15 — Schema Formalization** | LOW | Needs schema versioning and migration strategy. |

---

## Recommended Starting Sequence

```
10 (Memory Model) → 13 (Passes) → 09 (Compliance)
```

04 (Clay AST) is partially complete — core decisions locked 2026-06-28. Remaining §04 items (4 follow-on questions) are low-priority and can be addressed during §13 brainstorm. The critical path is now §10 and §13 (which can be brainstormed in parallel), followed by §09.

---

## Change Log

| Date | Change |
|---|---|
| 2026-06-26 | Initial priority list created from full section audit |
| 2026-06-28 | §04 Clay AST core decisions locked; moved from Critical to High tier; §13 ECS interaction contract gap closed; recommended sequence updated |
