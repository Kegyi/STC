# Section 04 — Clay AST & Compiler Architecture
**Reference file:** `docs/STC Co-Pilot & Systems Architect Reference Manual/sections/04_compiler_architecture_the_clay_ast.md`
**Last updated:** 2026-06-28

---

## What This Section Specifies
Defines the compiler's internal representation of a compiled topology as an ECS-based IR (EnTT registry), the component schema (what data is attached to each node/edge entity), the pass query contract (how passes declare and access component data), and the lifecycle rules governing component mutation across the four compilation phases.

---

## Locked Decisions
- **Component schema:** Flat typed catalog (Option A) — one struct per semantic concern; maps directly to EnTT sparse-set iteration for optimal pass performance
- **Core component types defined:** `NodeKindTag`, `SlaConstraint`, `CorePin`, `ProfileTag`, `EdgeTransport`, `MemoryDomain` — all with full field documentation in the spec
- **Query semantics:** Declarative YAML pass manifest (`reads` / `writes` / `phase` fields) + runtime dispatch by the executor — enables the executor to build a static parallelism graph before any pass runs
- **Component lifecycle:** Write-once per phase (Model II) — four phases: Ingest → Verify → Optimize → Codegen; components written in phase N are frozen (read-only) for N+1
- **Tooling exception:** Tagged union category grouping (Option C) is acceptable *only* for the Introspection Schema exposed to STC-LSP and debugger tooling — not for compiler-internal passes
- **Compliance fallback:** Immutable-after-ingest (Model I) is the mandatory fallback for compliance-only build profiles (ASIL-D / DO-178C targets with no optimizer passes registered)

---

## Open Questions / Tensions
- **Phase boundary enforcement:** What mechanism prevents an Optimize-phase pass from writing an Ingest-phase frozen component? (runtime assertion on registry write? compile-time pass attribute checked by the executor? registry write-mode flag per phase?)
- **Pass manifest schema:** YAML format shown in spec (`reads`, `writes`, `phase`) needs formal co-specification — belongs in §15 (Recipe Schema Formalization) or a dedicated pass-registry schema alongside the recipe grammar
- **Parallel scheduler design within a phase:** Manifests declare concurrency eligibility; the actual scheduling strategy (thread pool size, work-stealing vs. priority queue, error propagation when one pass in a parallel group fails) is unspecified
- **Component removal semantics:** The lifecycle model shows marker tags being removed after use (e.g., `NeedsCorePinning` removed after `CorePin` is assigned). The removal API, interaction with the freeze model, and safety rules are unspecified

---

## Compliance Implications
- EnTT's internal sparse-set storage uses `std::vector` internally — must be pre-reserved at compiler startup before entering any safety-critical compilation path to comply with ASIL-D / DO-178C no-heap-in-hot-path rules
- Phase-gated mutation (Model II) is the mechanism that enables the compliance-only fallback: safety profiles simply have no Optimize-phase passes registered, and the executor enforces the phase boundary automatically

---

## Cross-References
- **Section 13 — Compiler Passes:** Directly depended on this section; ECS interaction contract is now defined. §13 can proceed. Remaining §13 gaps: parallel stage execution model, error recovery flow
- **Section 10 — Memory Model:** `MemoryDomain` component is the bridge between the AST and the lifetime guarantee proofs specified in §10
- **Section 15 — Recipe Schema Formalization:** Pass manifest YAML format should be co-specified here; currently a §04 open question
- **Section 17 — Extension & Feature Integration:** Plugin passes must declare manifests; the lifecycle and query rules in this section apply to all plugin passes
