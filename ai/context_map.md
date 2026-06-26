# STC Context Map
**Purpose:** Cheap context injection for AI brainstorming sessions — use this instead of the full documents.  
**Generated:** 2026-06-25 | **Version:** 2026.1.0

---

## Core Concept (2-Paragraph Summary)

The **System-Topology Compiler (STC)** is a declarative compilation framework that transforms software architecture into an optimized, distributed binary by fully decoupling business logic from execution infrastructure. Developers write pure domain logic as stateless C++ Plain Old Data (POD) structures ("Lego Bricks"), while a YAML "Topology Recipe" defines the execution environment, hardware targets, protocols, and deployment constraints ("Clay"). The compiler weaves these together, synthesizing all glue code, network bindings, thread models, and CI/CD pipelines — without modifying the original logic.

The design philosophy is **Subtractive Physics Synthesis**: the compiler assumes zero OS, zero network stack, and zero framework, then adds back only what the target profile requires. This enables the same logical codebase to compile as a bare-metal ASIL-D automotive binary, a sub-nanosecond HFT trading engine, a 5G telecom gateway, or a Kubernetes cloud service — purely by swapping the YAML recipe. The compiler's internal representation is an **ECS-based AST (Clay AST)**, executed through a **Pass-DAG** of verifier and optimizer systems.

---

## Document Outline

| File | Purpose | Key Content |
|---|---|---|
| `docs/improvement_ideas/dynamic_swapping_proposals.md` | Swapping enhancement proposals | Compiler-synthesized strategy, POD state transfusion, formal verification loop |
| `docs/STC Architectural Core Reference/v2026.1.0.md` | Full architectural reference | Detailed pillar specs, CDB/PSA, compliance framework, memory model, transport taxonomy |
| `docs/STC Co-Pilot & Systems Architect Reference Manual/v2026.1.0.md` | **Authoritative reference manual** | All pillars, compiler passes, multi-language support, recipe schema formalization |
| `docs/STC Co-Pilot & Systems Architect Reference Manual/sections/` | Split sections of the manual | 19 focused files named NN_topic.md — share individually for deep dives |
| `docs/improvement_ideas/summary.md` | Improvement proposals | 4 improvement dimensions, production likelihood rankings, 3 open brainstorm directions |
| `docs/improvement_ideas/part_*.md` | Domain-specific expansions | Cloud SaaS, Telecom, MedTech, Robotics, IoT, Gaming, Aerospace, FinTech/HFT |

---

## The 5 Pillars (Quick Reference)

| Pillar | Name | What It Contains |
|---|---|---|
| **P1** | Functional Bricks | Pure C++ POD domain logic; stateless; no threads/network/DB; structured as a DAG |
| **P2** | Execution Physics | Threading models (TPC, Disruptor, Proactor, Reactor, Actor, WFI); I/O drivers (io_uring, epoll, DPDK) |
| **P3** | Data Connections | Protocol Bridges (JSON/gRPC/Protobuf → POD); CDB (cache commands); PSA (DB adapters); Result<T,E> wrappers |
| **P4** | Pipeline Interceptors | Zero-touch feature bundles (logging, audit, licensing, replication) injected onto graph edges by the compiler |
| **P5** | Infrastructure | OS targeting, packaging (binary/Docker), cluster orchestration, CI/CD generation, compliance traceability |

---

## 7 Core STC Principles (Quick Reference)

1. **Lego/Clay Principle** — Logical-Physical Decoupling. POD logic is independent of its execution environment.
2. **Subtractive Physics Synthesis** — Zero-Framework baseline. Compile up from bare metal, not down from a runtime.
3. **Isomorphic Bidirectionality** — Visual-Code Isomorphism. YAML ↔ GUI ↔ AST ↔ C++ always stay in sync.
4. **Lifetime Conservation** — Static Zero-Copy Lease. Compiler tracks data lifetimes; no heap allocations on edges.
5. **Temporal & Spatial Hermeticity** — Anti-Interference. Cache line alignment, CPU core pinning, Intel CAT/ARM MPAM.
6. **Reactive Physics** — Self-Morphing Adaptability. SLA guards on edges trigger RCU hot-swaps when latency degrades.
7. **Zero-Intrusion Observability** — Symmetric Telemetry. Lego blocks are blind; telemetry via ARM CoreSight / eBPF probes.

---

## Compiler Architecture (Quick Reference)

```
[C++ Source + YAML Recipe]
        ↓
  1. INGEST PASSTHROUGH  — Clang Tooling parser + JSON/YAML parser → ECS Registry
        ↓
  2. CLAY AST (ECS IR)   — Entities = node IDs; Components = properties; Systems = passes
        ↓
  3. PASS-DAG EXECUTOR   — WCET validation, static fusion, compliance checks, cache alignment
        ↓
  4. PLUGGABLE CODEGEN   — Target-specific backend plugins emit C++, P4, SystemC, K8s manifests
```

**Key compiler tools:** STC-LSP (real-time IDE diagnostics), Formal Constraint-Satisfaction Solver (WCET proofs, memory limits)

---

## Compilation Strategies

| Strategy | Profile | Technique | Use Case |
|---|---|---|---|
| **A** | High Flexibility | Polymorphic interfaces, dynamic decorators, ABI boundaries | Cloud SaaS, microservices, hot-swappable plugins |
| **B** | Ultra-Low Latency | Template metaprogramming (CRTP, Policy-Based Design), zero vtables, fused inline cache blocks | HFT, ASIL-D automotive, real-time embedded |

---

## Dynamic Swapping Patterns

| Pattern | Mechanism | Latency Cost | Risk |
|---|---|---|---|
| **RCU Atomic Pointer Swap** | `std::atomic<InterceptorAPI*>` + epoch-based reclamation | ~1 atomic load | Polling delay on `dlclose` |
| **Double-Buffer Active/Passive** | Dual route slices; traffic migrated; old slice drained | Near-zero | State schema must match |
| **State Deportation** | Live state transferred to new implementation before cutover | Higher | Schema evolution complexity |

**Key traps:** Mutex contention, use-after-free on `dlclose`, VMT ABI mismatch, `dlopen` violates MISRA/ASIL-D.

---

## Key Abstractions

| Abstraction | What It Does |
|---|---|
| **CDB (Context Database Handler)** | Abstract cache commands: `cdb->execute({"ZADD", "scores", "1", "user"})` — swaps between Redis-Lite (local) and Valkey/Enterprise (distributed) without touching logic |
| **PSA (Persistent Storage Adapter)** | Monadic compile-time DB contracts: `fetch_user()` — compiles to fused prepared statements or raw async writes |
| **Protocol Bridge** | Deserializes wire formats (JSON, gRPC, GTP-U) directly onto POD memory boundaries — zero-copy, SIMD-accelerated |
| **Feature Pack** | Compiler-injected decorator on a graph edge (e.g., DataReplication, AuditLog) — base modules are unaware |
| **Topology Recipe (YAML)** | The central contract: nodes, edges, targets, profiles, SLAs, compliance rules, CI/CD, packaging |
| **Archetype** | YAML node template eliminating duplicate configuration boilerplate |

---

## Compliance Profiles

| Profile | Rules Applied |
|---|---|
| `CloudSaaS` | Standard exceptions, dynamic alloc, normal logging |
| `iso_26262_automotive` / `ASIL-D` | No exceptions, no heap in hot path, `Result<T,E>`, static analysis (clang-tidy, Helix QAC), `safety_fault_handler` in graph |
| `DO-178C` (Avionics) | Same as ASIL-D + WCET formal proof, MPU isolation, ARINC 653 partitioning |
| `IEC 62304` (MedTech) | MPU walls, traceability to requirements (DOORS IDs), Class C/D rules |
| `MISRA-C++ 2023` | Bans `dlopen`, dynamic allocation, restricts pointer arithmetic |

---

## Standard Brick & Blueprint Catalog

**Infrastructure Bricks:** `io_multiplexer_epoll`, `io_driver_uring`, `io_blocking_worker`, `thread_pool_work_stealing`, `thread_pinned_core`, `event_loop_reactor`, `memory_ring_buffer_lockfree`, `storage_append_only_log`, `cache_lru_map`

**System Blueprints (pre-configured recipes):**
- **Redis-Lite:** `single_threaded_reactor` + `epoll` + In-Memory KV store
- **Kafka-Lite:** `thread_per_core` + async execution + `storage_append_only_log`
- **Nginx-Lite:** `multi_threaded_reactor` + event-driven network handlers

---

## Open Brainstorm Directions (from improvement_ideas/summary.md)

**Direction A — Schema-Driven Debugging & Live Introspection Protocol**  
Problem: After fusion/inlining, the logical graph is lost. GDB/LLDB can't map register states back to YAML.  
Goal: Compiler generates a companion **Introspection Schema** (metadata file) enabling a debugger plugin to reconstruct the logical graph state at runtime without instrumentation overhead.

**Direction B — Declarative Topological Conflict Resolution Solver**  
Problem: Conflicting execution profiles across edges (e.g., Interrupt-Driven Sleep node connected to Thread-Per-Core node).  
Goal: A **Constraint-Satisfaction Solver** in the compiler mid-end that auto-injects adapter nodes (ring buffers, wait-free registers, wake-up signals) to bridge incompatible physical execution boundaries.

**Direction C — Distributed Multi-Node Graph Orchestration (Clustered Clay Morphism)**  
Problem: Current scope is single-machine or split-silicon. SaaS/Telecom needs multi-server scale.  
Goal: Compiler accepts a unified logical graph and **compile-time partitions** it across physical cluster nodes, generating low-overhead network channels and distributed state consistency — bypassing heavy container orchestration.

---

## Glossary

| Term | Meaning |
|---|---|
| **POD** | Plain Old Data — C++ struct with no virtual methods, no hidden state, fully transparent memory layout |
| **DAG** | Directed Acyclic Graph — the data flow model for Pillar 1 execution |
| **ECS** | Entity-Component-System — data-oriented pattern used for the Clay AST |
| **Clay AST** | STC's ECS-based intermediate representation of the compiled topology |
| **Pass-DAG** | Ordered graph of compiler passes (verifiers + optimizers) executed over the Clay AST |
| **WCET** | Worst-Case Execution Time — timing bound formally proven by the compiler |
| **TPC** | Thread-per-Core — each thread pinned to a dedicated physical CPU core |
| **RCU** | Read-Copy-Update — lock-free pointer swap pattern for live reconfiguration |
| **VMT** | Virtual Method Table — avoided in Strategy B; destroys inlining and cache efficiency |
| **DPDK** | Data Plane Development Kit — kernel-bypass polling-mode NIC driver |
| **AF_XDP** | Linux kernel-bypass socket interface for zero-copy packet processing |
| **io_uring** | Linux async I/O submission ring (SQE/CQE model), zero kernel-transition overhead |
| **CAT / MPAM** | Intel Cache Allocation Technology / ARM Memory Partitioning and Monitoring — hardware cache isolation |
| **CRTP** | Curiously Recurring Template Pattern — compile-time polymorphism, zero vtable cost |
| **STC-LSP** | STC Language Server Protocol — IDE daemon for real-time topology recipe validation |
| **CDB** | Context Database Handler — abstract command interface to caching layers |
| **PSA** | Persistent Storage Adapter — monadic compile-time interface to persistent DB layers |
| **FDIR** | Fault Detection, Isolation, and Recovery — interceptor pattern used in aerospace/safety |
| **SHM** | Shared Memory — inter-process communication mechanism compiled from logical edges |
| **P4** | Programming Protocol-independent Packet Processors — SmartNIC/FPGA offload language |

---

## How to Use This File in Brainstorming Sessions

**Inject at session start (always):**
> `ai/context_map.md` + `ai/log_summary.md`

**For fine detail on a previous session:**
> Add `ai/logs/YYYY-MM-DD.md` for the relevant day

**For deep dives into a specific topic:**
| Topic | File to add |
|---|---|
| Compiler internals (Clay AST, passes) | `sections/04_compiler_architecture_the_clay_ast.md` |
| Core principles | `sections/03_core_compiler_principles.md` |
| Live swapping (implementation) | `sections/20_dynamic_swapping_implementation_patterns.md` |
| Swapping enhancement proposals | `docs/improvement_ideas/dynamic_swapping_proposals.md` |
| A domain (e.g., HFT) | `docs/improvement_ideas/part_12_FinTech_HFT.md` |
| Detailed section | `docs/STC Co-Pilot & Systems Architect Reference Manual/sections/NN_*.md` |

**After each session:**
1. Append entry to `ai/logs/YYYY-MM-DD.md` (create file if new day)
2. Update `ai/log_summary.md` with new decisions / open threads
