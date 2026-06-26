<!-- Part of: STC Co-Pilot & Systems Architect Reference Manual v2026.1.0 -->

## 20. Dynamic Swapping — Implementation Patterns

This section provides implementation-level detail for the three hot-swap execution patterns supported under Strategy A (Runtime Hot-Swap), as introduced in [Section 6](#6-dynamic-reconfiguration--live-morphing-operations). It includes known traps, C++ code notation, and an architectural trade-off evaluation.

---

### Traps & Critique of Naïve Strategy A Implementations

*   **Trap 1: Jitter & Mutex Contention.** Protecting runtime decorators with `std::shared_mutex` or standard locks to swap implementations will kill the Ultra-Low Latency (ULL) profile. In HFT/Automotive, lock acquisition overhead on graph edges in the hot path is unacceptable.
*   **Trap 2: Use-After-Free on `dlclose`.** Unloading the old `.so` immediately after swapping the pointer leads to segmentation faults if a worker thread is still executing inside the old library's memory space.
*   **Trap 3: Virtual Method Table (VMT) ABI Mismatch.** Relying on standard C++ class inheritance for plugins. Changing member layouts or virtual function order in the new `.so` breaks binary compatibility instantly.
*   **Trap 4: MISRA/Safety Violation.** `dlopen` relies on dynamic allocation and runtime linking, which violates MISRA-C++ and ASIL-D safety rules. *Dynamic swapping must be disabled or flagged as non-compliant in Safety-Critical profiles.*

---

### Option 1: Lock-Free Atomic RCU Pointer Swap (Epoch-Based)

This pattern uses a flat C-style ABI interface and an epoch-based memory reclamation scheme to swap edge-interceptor functions without stalling the reactor loop.

#### Topology & Flow
```
[I/O Reactor (io_uring)] ---> [Disruptor Ring Buffer]
                                      │
                                      ▼
                             [Core Graph Node A]
                                      │
                         Edge: [Atomic Decorator Ptr] ──(Current Epoch)──> [v1.so Interceptor]
                                      │
                                      ▼
                             [Core Graph Node B]
```

#### Code Notation (C++ POD / C-Interface)
```cpp
// ABI Stable Interface (Pure C Function Pointer Table)
struct InterceptorAPI {
    void (*on_edge_transit)(const void* payload, size_t size);
};

// Edge implementation holding active pointer and epoch tracking
class AtomicEdgeDecorator {
private:
    std::atomic<InterceptorAPI*> active_api{nullptr};
    std::atomic<uint64_t> thread_counters[64]{}; // Thread-local execution counters for epoch tracking

public:
    void execute(const void* payload, size_t size) {
        uint64_t tid = GetThreadId() % 64;
        thread_counters[tid].fetch_add(1, std::memory_order_acquire);

        InterceptorAPI* api = active_api.load(std::memory_order_consume);
        if (api && api->on_edge_transit) {
            api->on_edge_transit(payload, size);
        }

        thread_counters[tid].fetch_add(1, std::memory_order_release); // Return to even state
    }

    void swap_implementation(InterceptorAPI* new_api) {
        InterceptorAPI* old_api = active_api.exchange(new_api, std::memory_order_release);
        if (old_api) {
            quiesce_and_reclaim(old_api);
        }
    }

private:
    void quiesce_and_reclaim(InterceptorAPI* old_api) {
        // Wait until all thread-local counters are even (no thread is inside active execution)
        for (int i = 0; i < 64; ++i) {
            while (thread_counters[i].load(std::memory_order_acquire) % 2 != 0) {
                std::this_thread::yield();
            }
        }
        // Safe to unload .so / delete old_api
        reclaim_so_handle(old_api);
    }
};
```

*   **Pros:** Minimal latency overhead (~1 atomic load per edge). No packet drops; execution continues seamlessly.
*   **Cons:** Reclaiming memory (`dlclose`) requires active polling of thread epochs, delaying the actual unload of the old library.

---

### Option 2: Double-Buffered Active/Passive Routing

Instead of hot-swapping pointers on an active edge, the system duplicates the graph path. The old pipeline is fully drained of existing data packets while new packets are diverted to the new path.

#### Topology & Flow
```
                              [Incoming Data Flow]
                                       │
                                       ▼
                             [Active Route Selector]
                                  /         \
                      (Route A)  /           \  (Route B - Dormant / Upgraded)
                                ▼             ▼
                        [Node A (v1)]     [Node A (v2)]
                                │             │
                        [Interceptor v1]  [Interceptor v2]
                                \             /
                                 ▼           ▼
                                 [Node B Join]
```

#### Code Notation
```cpp
struct RouteSelector {
    enum class Path : uint8_t { RouteA, RouteB };
    std::atomic<Path> active_path{Path::RouteA};

    // Fast path selector without branch misprediction via array indexing
    template<typename FuncA, typename FuncB>
    inline void route(FuncA&& run_a, FuncB&& run_b) {
        if (active_path.load(std::memory_order_relaxed) == Path::RouteA) {
            run_a();
        } else {
            run_b();
        }
    }
};
```

*   **Process for Hot-Swap:**
    1. Load `v2.so` and instantiate all nodes for Route B.
    2. Atomic switch: `active_path.store(Path::RouteB, std::memory_order_release)`.
    3. Allow Route A execution threads to complete (determined by checking Disruptor sequence numbers).
    4. Unload `v1.so` once sequence counter confirms Route A is idle.
*   **Pros:** Zero memory hazards; clean handoff with complete state isolation.
*   **Cons:** Doubles memory footprint of the affected graph section during the swap transition.

---

### Option 3: Out-of-Process Shared Memory (SHM) Pipeline

Decoupled dynamic execution using lock-free shared memory rings (`io_uring` mapped SHM or raw rings). The main engine acts strictly as an I/O and routing reactor, delegating features to isolated processes.

#### Topology & Flow
```
 [Main Reactor Process] ──(SHM Lock-free Ring Write)──> [Dynamic Feature Process V1]
          │                                                       │
 (Active / Hot Swap)                                              ▼
          │                                            (Reads, Processes, Writes back)
          │                                                       │
          ▼                                                       ▼
 [Main Reactor Process] <──(SHM Lock-free Ring Read)──────────────┘
```

#### Code Notation
```cpp
struct SHMRingHeader {
    std::atomic<uint64_t> write_idx;
    std::atomic<uint64_t> read_idx;
    uint32_t ring_size;
    uint32_t unused;
};
// Reactor directs data pointers to SHM slot. Dynamic module pulls, processes, and marks ready.
```

*   **Process for Hot-Swap:**
    1. Start Process V2 reading from the same/new SHM segment.
    2. Change reactor's target SHM descriptor atomically to point to V2.
    3. Terminate Process V1.
*   **Pros:** Absolute crash isolation. A bug in the new module cannot crash the core I/O reactor. Zero ABI compatibility constraints on the C++ compiler version/standard of the `.so`.
*   **Cons:** Inter-process communication (IPC) serialization/deserialization latency overhead (typically 100ns–1µs depending on cache line sharing).

---

### Architectural Trade-off Evaluation

| Metric | Option 1: Lock-Free RCU | Option 2: Dual Routing | Option 3: SHM Sidecar |
| :--- | :--- | :--- | :--- |
| **Hot Path Latency** | **Excellent (< 2ns)** (atomic load) | **Very Good (~3ns)** (relaxed branch) | **Poor (100ns–1µs)** (IPC overhead) |
| **Memory Footprint** | Low (only dual library instances) | High (dual node pipeline allocation) | Medium (SHM structures) |
| **ABI Rigidity** | High (must enforce C linkage) | Medium (graph framework layout) | **None** (pure data boundaries) |
| **Safety Violation Risk** | High (pointer tracking errors) | Low (isolated graph paths) | **Zero** (completely isolated process) |
