<!-- Part of: STC Co-Pilot & Systems Architect Reference Manual v2026.1.0 -->

## 1. Foundational Paradigm: Logical vs. Physical Isolation

The System-Topology Compiler (STC) separates the **Logical Architecture** (domain-specific data transformation and control loops) from the **Physical Architecture** (hardware execution resources, memory domains, and network interfaces). 

```mermaid
graph LR
    subgraph Logical ["Logical Topology - Platform Agnostic"]
        NodeA["Node A: C++ POD"] -- "Logical Edge" --> NodeB["Node B: C++ POD"]
    end

    subgraph Physical ["Physical Execution - Target Optimized"]
        Core1["CPU Core 1 / L1 Cache"] -- "Lock-Free Direct Register / Bus" --> Core2["CPU Core 2 / L1 Cache"]
    end

    Logical -. "Mapped by STC Compile Pass" .-> Physical
    style Logical fill:#2e4053,stroke:#5d6d7e,color:#fff
    style Physical fill:#1a252f,stroke:#34495e,color:#fff
```

*   **Logical Decoupling:** Lego modules (Pillar 1 Bricks) contain purely mathematical, declarative, and sequential operations [1]. They do not configure, nor do they dynamically inspect, where they run or how they communicate.
*   **Physical Morphing:** The compiler maps logical edges to hardware execution mechanisms (Clay) [1]. An edge between Node A and Node B can compile to a direct register-to-register assembly instruction, a lock-free ring buffer (Disruptor) [1], an in-memory shared memory segment (SHM) [2], or a kernel-bypass network packet ([DPDK](#acronym-DPDK)/[AF_XDP](#acronym-AF_XDP)) [3], depending on the target environment profile declared in the YAML recipe.

<a id="core-architectural-pillars"></a>
