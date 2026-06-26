<!-- Part of: STC Co-Pilot & Systems Architect Reference Manual v2026.1.0 -->

## 9. Conditional Compliance Framework

The STC compiler switches its compilation strictness dynamically based on the declarative profile declared in the YAML recipe:

```mermaid
graph TD
    Ingest["Ingest: C++ POD Bricks & YAML"] --> Profile{Target Profile?}
    
    Profile -->|"Standard / Cloud"| StandardPass["Standard Comp Pass"]
    StandardPass -->|"Permit allocations"| StdCompile["Native GCC/Clang Build"]
    
    Profile -->|"Safety-Critical<br/>(MISRA / ASIL-D)"| SafetyPass["Strict Verification Pass"]
    SafetyPass -->|"1: AST Audit"| CheckAlloc{"Any malloc, new, or<br/>std::vector in hot path?"}
    
    CheckAlloc -->|Yes| Fail["Abort Compilation!<br/>(Throw Line & File Error)"]
    CheckAlloc -->|No| CheckExc{"Any throw or catch?"}
    
    CheckExc -->|Yes| Fail
    CheckExc -->|No| CheckWCET{"Worst-Case Execution<br/>Time & Memory Proofs?"}
    
    CheckWCET -->|Fail| Fail
    CheckWCET -->|Pass| SafeCompile["Fused Static Build<br/>(-fno-exceptions -fno-rtti)"]
    
    style Profile fill:#e67e22,stroke:#d35400,color:#fff
    style SafeCompile fill:#27ae60,stroke:#1e8449,color:#fff
    style Fail fill:#c0392b,stroke:#78281f,color:#fff
```

| Metric / Feature | Standard / Cloud Profile | Safety-Critical (MISRA / ASIL-D) Profile |
| :--- | :--- | :--- |
| **Heap Allocations** | Permitted during initialization; managed via local pools during runtime. | **Strictly Forbidden.** Zero dynamic allocation (`malloc`, `new`, `std::vector`) at runtime or boot [7]. |
| **Exception Handling** | Standard C++ `try`/`catch` blocks allowed. | **Forbidden.** Compile flag `-fno-exceptions` enforced. Error propagation strictly managed via stack-allocated monadic `Result<T, E>`. |
| **RTTI** | Standard Run-Time Type Information enabled. | **Forbidden.** Compile flag `-fno-rtti` enforced. Polymorphism resolved strictly compile-time via templates. |
| **Pointers** | Smart pointers (`std::shared_ptr`, `std::unique_ptr`) allowed. | **Forbidden.** Raw pointer arithmetic forbidden. Stack references and static offset indexes enforced. |
| **Worst-Case Execution Time** | Best-effort heuristic optimization. | **Formally Proven.** High-precision static WCET analysis determines boundary safety margins [7]. |

---

<a id="memory-model--data-lifetime-guarantees"></a>
