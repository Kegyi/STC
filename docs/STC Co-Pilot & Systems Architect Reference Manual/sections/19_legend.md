<!-- Part of: STC Co-Pilot & Systems Architect Reference Manual v2026.1.0 -->

## 19. Legend

This section provides definitions and expansions for the acronyms, abbreviations, and domain-specific terms used throughout the STC specifications.

*   **ACID:** Atomicity, Consistency, Isolation, Durability. A set of properties guaranteeing that database transactions are processed reliably.
*   **ADC:** Analog-to-Digital Converter. A hardware device that converts analog physical signals into digital numeric representations.
*   **AES-GCM:** Advanced Encryption Standard Galois/Counter Mode. A high-performance symmetric cryptographic algorithm providing both confidentiality and data origin authentication.
<a id="acronym-AF_XDP"></a>
*   **AF_XDP:** Address Family eXpress Data Path. A high-performance Linux network socket address family designed for zero-copy, kernel-bypass packet I/O.
*   **APEX:** Application Executive. The standardized ARINC 653 interface layer providing execution, memory, and communication partitioning APIs.
*   **ARINC 653:** Avionics Application Software Standard Interface. An aerospace standard defining time and space partitioning for Integrated Modular Avionics (IMA) systems.
*   **ASC:** Abstract Storage Contract. A compile-time, zero-allocation interface declaring data queries without referencing physical storage queries.
<a id="acronym-ASIL-D"></a>
*   **ASIL-D:** Automotive Safety Integrity Level D. The highest classification of hazard definition defined under the ISO 26262 safety standard.
*   **AST:** Abstract Syntax Tree. A tree-like representation of the abstract syntactic structure of source code.
*   **AVX / AVX-512:** Advanced Vector Extensions. SIMD instruction set extensions for the x86 microprocessor architecture.
*   **BSON:** Binary JSON. A serialization format used to store and transmit documents in a binary-encoded format.
*   **CAT:** Cache Allocation Technology. An Intel hardware-level resource management framework allowing software to control allocation of L3 cache spaces per core.
<a id="acronym-CDB"></a>
*   **CDB:** Context Database. An abstract, protocol-decoupled database and caching boundary wrapper (Pillar 3).
*   **CdbResult:** Context Database Result. A stack-allocated, zero-heap monadic result wrapper used to consume database/cache outputs without dynamic memory allocations.
*   **CHF:** Charging Function. A 5G core network entity responsible for real-time rating and online/offline billing.
*   **CNI:** Container Network Interface. A specification and library set for configuring network interfaces in Linux containers.
*   **CNF:** Containerized Network Function. A virtualized network function packaged and executed inside container runtimes.
*   **CRIU:** Checkpoint/Restore In Userspace. A Linux software utility allowing active processes to be frozen and snapshotted to disk for instant restoration.
*   **DAG:** Directed Acyclic Graph. A directed graph with no structural cycles; used by STC to model data pipelines and compilation passes.
*   **DDS:** Data Distribution Service. A middleware standard for data-centric publish-subscribe communications in real-time distributed systems.
*   **DIP:** Dependency Inversion Principle. A software engineering design pattern where high-level modules depend on abstractions rather than low-level implementations.
*   **DO-178C:** Software Considerations in Airborne Systems and Equipment Certification. The primary regulatory standard used by aviation authorities to approve commercial software-based aerospace systems.
<a id="acronym-DPDK"></a>
*   **DPDK:** Data Plane Development Kit. A set of user-space libraries and polling-mode drivers designed to bypass the operating system kernel for high-speed packet processing.
*   **DPI:** Deep Packet Inspection. A method of network packet filtering that examines the data field of a packet as it passes an inspection point.
*   **DSL:** Domain-Specific Language. A highly specialized programming language designed to solve a specific problem domain (e.g., STC's topology YAML).
<a id="acronym-eBPF"></a>
*   **eBPF:** Extended Berkeley Packet Filter. An in-kernel virtual machine in Linux allowing safe, zero-overhead execution of custom monitoring and packet-filtering sandboxes.
*   **ECC:** Error-Correcting Code. A system of adding redundant data to memory blocks to detect and correct hardware-level single-bit errors.
*   **ECS:** Entity-Component-System. A data-oriented design pattern where entities are unique IDs, components are raw data fields, and systems are execution loops; used by the STC Clay AST.
*   **FDIR:** Fault Detection, Isolation, and Recovery. A spacecraft/aircraft engineering framework designed to dynamically isolate system-level faults.
*   **FIX:** Financial Information eXchange. An industry-standard session-layer protocol used for real-time electronic financial transactions.
*   **FOTA:** Firmware-Over-The-Air. Wireless transmission of system firmware updates directly to remote embedded microcontrollers.
*   **GDPR:** General Data Protection Regulation. EU regulatory frameworks governing personal data protection and privacy.
*   **GPIO:** General-Purpose Input/Output. Physical, uncommitted pins on microcontrollers that can be dynamically controlled by software at runtime.
*   **GTP-U:** GPRS Tunneling Protocol User Plane. An IP-based communications protocol used in 5G cellular networks to carry user plane data packets.
*   **HLS:** High-Level Synthesis. An automated design process that compiles algorithmic C++ descriptions directly into hardware-level RTL/FPGA bitstreams.
*   **HMAC-SHA256:** Keyed-Hash Message Authentication Code. A cryptographic authentication method utilizing the SHA-256 hash function.
*   **HPA:** Horizontal Pod Autoscaler. A Kubernetes system that dynamically scales the number of active container replicas based on system load.
*   **HSM:** Hardware Security Module. A physical, tamper-resistant computing device safeguarding and managing digital keys.
*   **IEC 62304:** Medical device software — Software life cycle processes. An international standard regulating the design and development of medical device software.
*   **IMA:** Integrated Modular Avionics. Shared, standardized computer networks and hardware platforms used on commercial and military aircraft.
*   **IR:** Intermediate Representation. The internal, compiler-specific data structure used to represent source code during optimization and compilation passes.
*   **ISO 26262:** Road vehicles — Functional safety. An international standard regulating the development of safety-critical automotive electronic systems.
*   **ISP:** Interface Segregation Principle. A design pattern stating that software components should not be forced to depend on data fields they do not use.
*   **LMAX:** An asynchronous, single-writer, lock-free ring buffer design pattern (the Disruptor) optimized for financial exchange platforms.
*   **LSP:** Language Server Protocol. An open protocol standard providing IDEs with auto-complete, diagnostics, and semantic analysis from an external compiler daemon.
*   **MCU:** Microcontroller Unit. A small, low-power, single-chip computer containing processors, memory, and programmable I/O peripherals.
<a id="acronym-MISRA"></a>
*   **MISRA:** Motor Industry Software Reliability Association. A set of strict C/C++ coding guidelines designed to prevent unsafe, undefined, or non-deterministic operations in critical environments.
*   **MMU:** Memory Management Unit. A hardware component in CPUs that translates virtual memory addresses to physical RAM layouts.
*   **MPAM:** Memory System Resource Partitioning and Monitoring. An ARM hardware-level framework providing cache and memory bandwidth partitioning per thread.
*   **MPU:** Memory Protection Unit. A simplified hardware-level memory controller in microcontrollers providing access control but no virtual mapping.
*   **NEON:** The advanced SIMD architecture extension designed for ARM microprocessors.
*   **O-DU:** Open Distributed Unit. A logical node in 5G Open RAN architectures executing real-time RLC, MAC, and physical-layer sub-functions.
*   **O-RAN:** Open Radio Access Network. A standardized, open-architecture framework for virtualized cellular radio access networks.
*   **ORM:** Object-Relational Mapper. A programming technique that maps relational database structures to object-oriented memory layers.
*   **PCI-DSS:** Payment Card Industry Data Security Standard. Information security standards regulating credit card processing environments.
*   **PCGI:** Polymorphic Code-Generated Interface. A compile-time interface synthesized by the compiler to bypass virtual method dispatch.
*   **PII:** Personally Identifiable Information. Any data that can be used to distinguish or trace an individual's identity.
*   **PMD:** Polling-Mode Driver. A high-performance driver design pattern that bypasses hardware interrupts, continuously polling device status registers directly.
*   **PMU:** Performance Monitoring Unit. A specialized hardware block in microprocessors designed to count hardware-level event cycles (cache misses, branch mispredictions).
<a id="acronym-POD"></a>
*   **POD:** Plain Old Data. Standard C++ data structures containing no virtual tables, references, or dynamic allocations; guaranteeing continuous, predictable binary layouts.
*   **POSIX:** Portable Operating System Interface. A family of standards defining API compatibility layers across Unix-like operating systems.
<a id="acronym-PSA"></a>
*   **PSA:** Persistent Storage Adapter. An abstract, monadic, compile-time query interface used by STC to decouple databases from business logic (Pillar 3).
*   **PT:** Processor Trace. An Intel microprocessor feature designed to capture real-time execution branches without introducing instruction-level instrumentation overhead.
*   **PVC:** Persistent Volume Claim. A Kubernetes resource request for durable, persistent storage volumes.
<a id="acronym-RCU"></a>
*   **RCU:** Read-Copy-Update. A lock-free synchronization pattern that allows reader threads to access memory concurrently while writer threads execute updates in-place.
*   **RDMA:** Remote Direct Memory Access. A network technology allowing direct memory transfers between computers without invoking either system's OS kernel or CPU cores.
*   **RESP:** REdis Serialization Protocol. A lightweight, human-readable, high-performance binary-safe serialization protocol used by Redis and Valkey caching engines.
*   **RoCEv2:** RDMA over Converged Ethernet. A high-speed network protocol allowing RDMA transmissions over standard Ethernet networks.
*   **ROS / ROS2:** Robot Operating System. A flexible, modular, middleware framework containing tools and libraries used to build complex robotic platforms.
*   **SBE:** Simple Binary Encoding. An ultra-low-latency, zero-copy, binary-safe serialization scheme optimized for high-frequency trading platforms.
*   **SECDED:** Single Error Correction, Double Error Detection. An ECC memory scrubbing algorithm designed to recover from single-bit hardware flips and trap double-bit corruptions.
*   **SEU:** Single-Event Upset. A radiation-induced state change in a microprocessor memory latch or register.
*   **SIMD:** Single Instruction, Multiple Data. A processor design paradigm executing a single vector operation across multiple data points in parallel.
*   **SLA:** Service Level Agreement. Declarative, non-functional requirements (such as latency bounds, throughput, and memory allocations) enforced by the STC compiler.
*   **SMF:** Session Management Function. A 5G core network entity managing cellular user plane session lifecycles.
*   **SR-IOV:** Single Root I/O Virtualization. A hardware virtualization specification allowing a single physical PCIe device to appear as multiple isolated virtual devices.
*   **SRP:** Single Responsibility Principle. A software design pattern enforcing that every module or class must be responsible for exactly one logical concern.
*   **TMR:** Triple Modular Redundancy. A fault-tolerant system design pattern where three identical processes execute in parallel and output consensus states via voting nodes.
*   **TPC:** Thread-per-Core. An execution model where single execution loops are pinned to dedicated physical cores, completely eliminating operating system scheduling jitter.
*   **UPF:** User Plane Function. The core user plane packet processing and routing engine of 5G cellular network infrastructures.
*   **VMT:** Virtual Method Table (or vtable). A dispatch mechanism used in C++ to resolve virtual function calls at runtime.
*   **VNF:** Virtualized Network Function. Software-based network functions executed on standard virtualized cloud infrastructure.
*   **WAN:** Wide Area Network. A telecommunications network extending across large geographical distances.
<a id="acronym-WCET"></a>
*   **WCET:** Worst-Case Execution Time. The maximum statically provable duration an algorithmic block can take to execute on a target processor.
*   **WFI:** Wait For Interrupt. A hardware assembly instruction designed to place low-power microprocessors into standby sleep states until an external interrupt triggers.
*   **XDP:** eXpress Data Path. A high-performance, kernel-bypass Linux network routing layer executing directly at the network driver interface.
