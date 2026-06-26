<!-- Part of: STC Co-Pilot & Systems Architect Reference Manual v2026.1.0 -->

## 4. Compiler Architecture & The Clay AST

The STC compiler utilizes a data-oriented execution pipeline built on a highly parallelizable, entity-component intermediate representation.

```mermaid
graph TD
    Ingest["STC Ingest Parser<br/>(Clang Tooling + YAML/JSON)"] -->|Write to| Registry["The Clay AST<br/>(EnTT ECS Registry)"]
    
    subgraph ECS ["Entity-Component-System IR"]
        Entities["Entities<br/>(Node, Edge, Target IDs)"]
        Components["Components<br/>(Type, SLA, Pin, Memory Domain)"]
        Entities -. Holds .-> Components
    end
    
    Registry -->|Input to| Executor["Pass-DAG Executor<br/>(System Schedulers)"]
    
    subgraph Passes ["Pass-DAG Compilation Systems"]
        V1["Static Verifiers<br/>(ASIL-D Alloc, MISRA, Cycles)"]
        O1["Optimizers<br/>(Inline Fusion, Reg Alloc, Slices)"]
    end
    
    Executor --> V1
    Executor --> O1
    O1 -->|Emit| TargetIR["Unified Target IR"]
    TargetIR -->|Link| Codegen["Polymorphic Codegen Backends<br/>(Integration Strategies)"]
    Codegen -->|Write| Output["Physical Code & Manifests<br/>(.bin, .tar, K8s YAML)"]
    
    style ECS fill:#1d2a44,stroke:#31496b,color:#fff
    style Passes fill:#0b132b,stroke:#1c2541,color:#fff
```

### 1. The Clay AST (ECS-Based Intermediate Representation)
To resolve the "Expression Problem" and support modular, dynamic extensions:
*   **Entities:** Every node, edge, and target in the compiler graph is represented as a unique integer ID.
*   **Components:** Syntactic, semantic, and non-functional properties (such as source locations, sample rates, network protocols, and hardware pin mappings) are appended to these entities as flat, memory-aligned structures in an entity component registry.
*   **Systems:** Compiler passes run as decoupled systems that query specific component patterns (e.g., a system that checks for physical rate mismatches across edges and injects queue adapters).

### 2. The Pass-DAG Executor
The compilation stages themselves run as a Directed Acyclic Graph (DAG) of independent compilation passes. The compiler's execution engine loads, wires, and schedules compile passes dynamically based on the target configuration.

### 3. Verification & Constraints
Before code generation, the compiler executes formal validation passes:
*   *Temporal Constraint Solver:* Proves that hard real-time execution blocks meet Worst-Case Execution Time ([WCET](19_legend.md#acronym-WCET)) bounds.
*   *Memory Guard:* Proves that static memory allocations do not exceed target embedded hardware SRAM/Flash limits.
*   *Compliance Verifier:* Audits AST structures to ensure zero dynamic memory allocations on safety-critical paths.

---

<a id="declarative-topology-recipe-specification-yaml"></a>
