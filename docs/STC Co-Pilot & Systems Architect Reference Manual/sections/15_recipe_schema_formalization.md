<!-- Part of: STC Co-Pilot & Systems Architect Reference Manual v2026.1.0 -->

## 15. Recipe Schema Formalization

The YAML topology recipe is the single contract that governs everything the STC compiler produces. Sections 5 through 13 describe what the compiler does with the recipe; this section defines the **complete schema** of the recipe itself — every key, its type, its constraints, and whether it is required or optional. This schema is the authoritative reference for tooling (IDE autocomplete, linters, CI validators) and for the P1 YAML Recipe Parser.

The schema is specified here in an annotated reference format. A machine-readable JSON Schema file (`stc-recipe.schema.json`) and a YAML Schema file (`stc-recipe.schema.yaml`) are distributed with the STC toolchain and are registered automatically with the LSP daemon to provide inline validation in supported editors.

---

### 1. Top-Level Structure

The recipe file must contain exactly one root key: `topology`. All other top-level keys are rejected with `STC-P01-002`.

```yaml
topology:                       # REQUIRED. Root key. No siblings permitted.
  name: string                  # REQUIRED. Unique identifier for this topology. [a-zA-Z0-9_-], max 128 chars.
  version: string               # OPTIONAL. Semver string (e.g. "1.0.0"). Defaults to "0.0.0".
  description: string           # OPTIONAL. Human-readable summary. No compiler effect.

  extends: string | <ExtendsRef> # OPTIONAL. Base recipe to extend. Resolved at P1 before all other keys.
                                 # String form: relative file path to a .yaml recipe file.
                                 # Object form: { ref: "<name>@<version>", catalog: "<source_name>" }
                                 # See §17 for extension rules and incremental compilation.

  catalog: <CatalogBlock>       # OPTIONAL. Defaults to local filesystem catalog at ./.stc/catalog.
  type_schemas: [<TypeSchemaEntry>] # OPTIONAL. Language-neutral port type schema sources. See §16.1.
                                    # Each entry: { path: string } | { git: string, ref: string, path: string }
  profiles: <ProfilesBlock>     # OPTIONAL. Environment overlay declarations.
  targets: <TargetsBlock>       # REQUIRED unless all targets are inherited via extends:.
  archetypes: <ArchetypesBlock> # OPTIONAL. Reusable node configuration templates.
  nodes: [<NodeEntry>]          # REQUIRED. At least one node must be declared.
  edges: [<EdgeEntry>]          # OPTIONAL. A topology with no edges is valid (single-node system).
```

---

### 2. `CatalogBlock`

```yaml
catalog:
  sources:                      # REQUIRED if catalog block is present. Ordered list; first-match wins.
    - type: string              # REQUIRED. One of: "local" | "git" | "registry".

      # --- type: "local" ---
      path: string              # REQUIRED for local. Relative or absolute filesystem path.

      # --- type: "git" ---
      url: string               # REQUIRED for git. SSH or HTTPS URL to a bare Git repository.
      ref: string               # OPTIONAL for git. Branch, tag, or commit SHA. Defaults to "main".

      # --- type: "registry" ---
      url: string               # REQUIRED for registry. HTTPS URL to STC Registry Server.
      auth: string              # OPTIONAL for registry. One of: "none" | "token" | "mtls". Defaults to "none".

  resolution: string            # OPTIONAL. One of: "first-match" | "strict-first". Defaults to "first-match".
                                # "strict-first": if brick found in source N, sources N+1..M are not queried.
                                # "first-match": identical to strict-first (reserved for future "merge" mode).
```

---

### 3. `ProfilesBlock`

Profiles are named overlay maps. Each key under a profile name is a dot-path into the `topology` tree; the value replaces the resolved value at that path for any build invoked with `--profile=<name>`.

```yaml
profiles:
  <profile_name>:               # OPTIONAL, repeatable. Identifier: [a-zA-Z0-9_-].
    <dot.path.key>: <value>     # OPTIONAL, repeatable. Dot-path must resolve to an existing key in the schema.
                                # Compiler emits STC-P01-004 if the path does not resolve.
```

**Constraints:**
- Profile names may not be `default`, `base`, or `override` (reserved).
- Overlay values are type-checked against the schema of the key they target. A string overlay on a boolean key is `STC-P01-002`.
- Profiles are purely additive overlays — they cannot delete keys, only replace scalar values or append to lists.

---

### 4. `TargetsBlock`

```yaml
targets:
  <target_name>:                # REQUIRED, repeatable. Identifier: [a-zA-Z0-9_-].

    # --- Hardware identity ---
    arch: string                # REQUIRED. Target architecture. See Architecture Registry (§15.7).
    os: string                  # REQUIRED. Target OS. See OS Registry (§15.8).

    # --- Compliance profile ---
    profile: string             # OPTIONAL. Named compliance profile. See Profile Registry (§15.9).
                                # If omitted, defaults to "Standard".

    # --- Memory limits (embedded targets) ---
    sram_limit: string          # OPTIONAL. e.g. "256KB", "2MB". Required when profile demands Memory Guard.
    flash_limit: string         # OPTIONAL. e.g. "1MB". Required when profile demands Memory Guard.

    # --- Hardware isolation ---
    mpu_isolation: boolean      # OPTIONAL. Enables MPU region generation. Defaults to false.
    cache_partition: string     # OPTIONAL. Intel CAT / ARM MPAM partition ID for this target's threads.

    # --- Execution model ---
    execution_model: string     # OPTIONAL. One of: "ThreadPerCore" | "Disruptor" | "InterruptDriven".
                                # Defaults to "ThreadPerCore" for linux targets, "InterruptDriven" for MCUs.
    core_pins: [integer]        # OPTIONAL. List of physical CPU core IDs to pin threads to.

    # --- Caching (Pillar 3 CDB) ---
    cache:
      deployment_mode: string   # OPTIONAL. One of: "embedded" | "systemd" | "kubernetes". Defaults to "embedded".
      engine: string            # OPTIONAL. One of: "redis-lite" | "valkey" | "redis-enterprise".

    # --- Networking ---
    namespace: string           # OPTIONAL. Kubernetes namespace. Only valid when os: "kubernetes".
    network_interface: string   # OPTIONAL. Physical NIC name for DPDK/AF_XDP targets (e.g. "eth0", "ens3").

    # --- Language & toolchain ---
    lang: string                # REQUIRED. Implementation language for all bricks on this target.
                                # One of: "cpp" | "kotlin" | "typescript" | "rust" | "python".
                                # Unknown values emit STC-P01-004.
    jvm_min_api: integer        # OPTIONAL. Minimum Android API level. lang: "kotlin" only.
    framework: string           # OPTIONAL. Front-end framework adapter. lang: "typescript" only.
                                # One of: "react" | "vue" | "svelte" | "none". Defaults to "none".
    no_std: boolean             # OPTIONAL. Enforce no_std Rust build. lang: "rust" only. Defaults to false.

    # --- Pin map (embedded targets) ---
    pin_map:                    # OPTIONAL. Maps logical signal names to physical hardware pin identifiers.
      <signal_name>: string     # e.g. sensor_analog_in: "ADC1_CH2"
```

---

### 5. `ArchetypesBlock`

```yaml
archetypes:
  <archetype_name>:             # OPTIONAL, repeatable. Identifier: [a-zA-Z0-9_-].
    brick: string               # OPTIONAL. Brick reference "<name>@<version_spec>".
    bundle: string              # OPTIONAL. Bundle reference "<name>@<version_spec>". Exclusive with brick.
    target: string              # OPTIONAL. Must reference a declared target name. Exclusive with deploy_to.
    deploy_to: [string]         # OPTIONAL. List of target names. Exclusive with target.
                                # P6 expands any node using this archetype into one instance per listed target.
                                # See §16.4 for expansion rules.
    sample_rate_hz: integer     # OPTIONAL. Passed to the brick as a compile-time parameter.
    constraints:                # OPTIONAL. Override brick-level constraint defaults.
      no_heap: boolean
      no_exceptions: boolean
      max_stack_bytes: integer
    # Any additional key is treated as a named parameter forwarded to the brick's STC_PARAM annotations.
    # Unknown keys that are not STC_PARAM targets emit STC-P06-001.
```

---

### 6. `NodeEntry`

```yaml
nodes:
  - name: string                # REQUIRED. Unique node identifier: [a-zA-Z0-9_-], max 128 chars.
                                # Two nodes with the same name in the same topology is STC-P01-002.

    # --- Brick resolution (exactly one of the following groups is required) ---
    brick: string               # Group A. Catalog brick reference: "<name>@<version_spec>".

    bundle: string              # Group B. Catalog bundle reference: "<name>@<version_spec>".
                                # Instantiates a Level 3 Logic Bundle. See §11.6.

    archetype: string           # Group C. Reference to a declared archetype name.
    overrides:                  # Group C only. Key-value map of archetype parameter overrides.
      <parameter_name>: <value>

    # --- Placement (one of target or deploy_to is required unless provided by archetype) ---
    target: string              # Single-target form. Must reference a declared target name.
                                # Mutually exclusive with deploy_to.
    deploy_to: [string]         # Multi-target form. List of declared target names.
                                # P6 expands this node into one Clay AST entity per listed target,
                                # selecting the correct language implementation for each.
                                # Expanded instances are addressable as "<NodeName>@<target>".
                                # An edge connecting two deploy_to nodes with identical target lists
                                # auto-expands in parallel. Mismatched lists emit STC-P06-002.

    # --- Execution physics (Pillar 2) ---
    thread_affinity: integer    # OPTIONAL. Physical core ID. Overrides target-level core_pins for this node.
    priority: integer           # OPTIONAL. OS thread priority (SCHED_FIFO level for RT targets).

    # --- Pipeline interceptors (Pillar 4) ---
    interceptors:               # OPTIONAL. List of interceptor declarations attached to this node's edges.
      - source: string          # REQUIRED per interceptor. C++ header path.
        logic_type: string      # REQUIRED per interceptor. C++ class name.
        strategy: string        # OPTIONAL. One of: "A" (runtime) | "B" (static-fusion). Defaults to "A".
        applies_to: string      # OPTIONAL. One of: "all_inputs" | "all_outputs" | "<port_name>". Defaults to "all_inputs".

    # --- State persistence ---
    state_type: string          # OPTIONAL. C++ POD struct name holding node state between invocations.
    psa:                        # OPTIONAL. Persistent storage adapter binding for this node.
      adapter: string           # REQUIRED if psa block present. Brick reference or source path for the PSA.
      logic_type: string        # REQUIRED if source path form used.

    # --- Telemetry ---
    telemetry:                  # OPTIONAL. Per-node telemetry overrides.
      enabled: boolean          # OPTIONAL. Defaults to true.
      probe_type: string        # OPTIONAL. One of: "intel_pt" | "arm_coresight" | "ebpf" | "software".
                                # Overrides compiler auto-selection from target hardware capabilities.
```

---

### 7. `EdgeEntry`

```yaml
edges:
  - from: string                # REQUIRED. "<node_name>.<port_name>" or "<wildcard>.<port_name>".
                                # Wildcard: any glob pattern matching node names (e.g. "Sensor*").
    to: string                  # REQUIRED. "<node_name>.<port_name>".
                                # Wildcards are not permitted on the "to" side.

    # --- Transport (see Section 12) ---
    transport:                  # OPTIONAL. If absent, compiler auto-selects via Transport Selection Pass (P5).
      layer: integer            # OPTIONAL. Explicit layer override: 0 | 1 | 2 | 3.
      primary:                  # OPTIONAL. Explicit primary protocol (Layer 3 only).
        protocol: string        # See Transport Taxonomy table in §12.1.
        serialization: string   # One of: "SBE" | "Protobuf" | "JSON" | "raw".
        ring_capacity: integer  # OPTIONAL. Layer 1 only. Must be power of 2. Defaults to 1024.
        wait_strategy: string   # OPTIONAL. Layer 1 only. "BusySpin" | "Yielding" | "Sleeping" | "BlockingWait".
        queue_depth: integer    # OPTIONAL. Layer 3 only. Defaults to 2048.
        custom_bridge_source: string  # OPTIONAL. C++ header for a custom serializer/deserializer bridge.
      fallback:                 # OPTIONAL. Ordered list of fallback transports (Strategy A only).
        - protocol: string      # REQUIRED per fallback entry.
          trigger: string       # REQUIRED. One of: "sla_breach" | "sla_breach_critical" | "connection_lost".

    # --- SLA (Service Level Agreement) ---
    sla:                        # OPTIONAL. If absent, no SLA monitoring is synthesized on this edge.
      max_latency_us: integer   # OPTIONAL. Exclusive with max_latency_ms.
      max_latency_ms: integer   # OPTIONAL. Exclusive with max_latency_us.
      delivery_guarantee: string  # OPTIONAL. "BestEffort" | "AtLeastOnce" | "ExactlyOnce".
                                  # See transport compatibility table in §12.5.
      ordering_guaranteed: boolean  # OPTIONAL. Defaults to false.
      encryption: string        # OPTIONAL. "TLS_1_3" | "AES_GCM_256". Layer 3 / TLS-capable protocols only.
      max_queue_depth: integer  # OPTIONAL. Maximum in-flight message count before backpressure.
      breach_threshold: integer # OPTIONAL. Consecutive violations before swap triggers. Defaults to 3.
      recovery_window_ms: integer  # OPTIONAL. Sustained SLA compliance duration before restoring primary. Defaults to 500.
```

---

### 8. Architecture Registry

Valid values for `targets.<name>.arch`:

| Value | Description |
| :--- | :--- |
| `x86_64-linux` | 64-bit x86 Linux (bare or containerized) |
| `aarch64-linux-gnu` | 64-bit ARM Linux (Raspberry Pi, AWS Graviton, etc.) |
| `armv7-linux-gnueabihf` | 32-bit ARMv7 Linux with hardware FPU |
| `stm32h7` | STMicroelectronics STM32H7 Cortex-M7 MCU |
| `stm32f4` | STMicroelectronics STM32F4 Cortex-M4 MCU |
| `nxp-imx8` | NXP i.MX8 Cortex-A53/A72 SoC |
| `riscv32-none` | 32-bit RISC-V bare-metal |
| `riscv64-linux` | 64-bit RISC-V Linux |
| `fpga-hls` | FPGA target (HLS bridge, experimental) |

New architectures are registered by adding an architecture descriptor to the STC compiler's `arch-registry.yaml` configuration file distributed with the toolchain.

---

### 9. OS Registry

Valid values for `targets.<name>.os`:

| Value | Description |
| :--- | :--- |
| `linux` | Standard Linux (glibc or musl) |
| `kubernetes` | Linux containerized, deployed via Kubernetes manifests |
| `freertos` | FreeRTOS real-time kernel |
| `zephyr` | Zephyr RTOS |
| `qnx` | QNX Neutrino RTOS |
| `pikeos` | PikeOS safety RTOS (ARINC 653 / POSIX) |
| `baremetal` | No OS — compiler synthesizes the entire execution loop |

---

### 10. Profile Registry

Valid values for `targets.<name>.profile`:

| Value | Activates |
| :--- | :--- |
| `Standard` | Default. No additional compliance checks beyond structural integrity. |
| `CloudSaaS` | Standard + container packaging + K8s manifest generation. |
| `ThreadPerCore` | Standard + core-pinning enforcement + Disruptor ring validation. |
| `ASIL_D` | Full safety suite: P9 compliance, P11 WCET, P12 memory guard, `-fno-exceptions`, `-fno-rtti`. |
| `MedTech_Class_C` | IEC 62304 Class C: same checks as ASIL_D plus audit trail generation. |
| `DO178C` | DO-178C Level A: same checks as ASIL_D plus formal WCET proof artifacts written to build output. |
| `MISRA_CPP` | MISRA-C++ 2023 rule set enforced by P9 on top of Standard profile. |

Profiles are additive — `ASIL_D` activates all checks that `ThreadPerCore` activates, plus more. A target may declare only one profile; profiles cannot be combined. Stricter requirements must be expressed by choosing the highest applicable profile.

---

<a id="multi-language-target-support"></a>
