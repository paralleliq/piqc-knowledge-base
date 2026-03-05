# Performance Analysis: The Three Fundamental Regimes

When analyzing the performance of modern systems (CPUs, GPUs, and distributed systems), most bottlenecks fall into three fundamental regimes:

- Compute Bound
- Memory Bound
- Latency Bound

Identifying which regime a workload belongs to is the first step toward diagnosing and optimizing performance.

## Compute Bound

A workload is compute bound when the primary limitation is the rate at which the processor can execute instructions.  In this regime, the execution units (ALUs, FPUs, tensor cores, etc.) are fully utilized.

Typical indicators:

- High CPU/GPU utilization
- High IPC
- Low memory stall time

Execution units near saturation

### Key Terms

**IPC (Instructions Per Cycle)**

IPC measures how many instructions the processor completes each clock cycle.

```bash
IPC = Instructions / Cycles
```

Higher IPC usually means the processor pipeline is being efficiently utilized.  Example:

```bash
IPC = 3.5
```

means the processor completes about 3.5 instructions every cycle.

**CPI (Cycles Per Instruction)**

CPI is the inverse of IPC.

```bash
CPI = Cycles / Instructions
```

Lower CPI indicates faster execution.

**Pipeline Stall** 

A pipeline stall occurs when the processor cannot execute the next instruction due to missing data or resources.  Common causes:

- Waiting for memory
- Instruction dependency
- Branch misprediction
- Instruction Dependency

Occurs when an instruction needs the result of a previous instruction before it can execute.  Example:

```bash
a = b + c
d = a * e
```

The second instruction must wait for the first to complete.

**Branch Misprediction**

Modern processors attempt to predict the outcome of branch instructions.  If the prediction is incorrect:

- The pipeline is flushed
- Instructions must be re-fetched
- Execution temporarily stalls

Branch-heavy code with unpredictable branches can suffer significant performance penalties.

GPU Equivalent: Warp Execution

On GPUs, threads execute in groups called warps.  Compute-bound GPU workloads typically show:

- High SM utilization
- High arithmetic throughput
- Low memory stalls

## Memory Bound

A workload is memory bound when performance is limited by memory bandwidth or memory access patterns.  In this regime, processors frequently wait for data from the memory hierarchy.  Typical indicators:

- High cache miss rates
- High memory bandwidth usage
- Low IPC
- Frequent memory stalls

### Key Terms

**Cache Hit**

A cache hit occurs when requested data is found in the cache.  This results in fast access.

**Cache Miss**

A cache miss occurs when the requested data is not present in the current cache level.  The processor must fetch it from the next level in the hierarchy.

Typical memory hierarchy:

```bash
L1 → L2 → L3 → DRAM
```

Latency increases at each level.

**LLC Miss Rate**

LLC stands for Last Level Cache, typically the L3 cache.

```bash
LLC Miss Rate = LLC Misses / LLC Accesses
```

A high LLC miss rate indicates frequent access to DRAM.

**Memory Latency**

Memory latency is the time required to retrieve data from memory.  Typical latencies:

| Memory Level | Latency        |
|--------------|----------------|
| L1 Cache     | ~1–4 cycles    |
| L2 Cache     | ~10 cycles     |
| L3 Cache     | ~40 cycles     |
| DRAM         | ~100–200 cycles|

**Memory Bandwidth**

Memory bandwidth refers to the maximum rate at which memory can supply data.  Examples:

| Memory Type | Approximate Bandwidth |
|-------------|-----------------------|
| DDR5        | ~100 GB/s             |
| HBM         | ~1 TB/s               |

When applications require more data than the system can provide, the workload becomes bandwidth bound.

**Memory Pressure**

Memory pressure occurs when an application generates a high volume of memory accesses that stress the memory subsystem.  Symptoms include:

- Cache thrashing
- High miss rates
- Saturated memory bandwidth
- GPU Memory Coalescing

On GPUs, memory accesses are most efficient when threads access contiguous memory locations.  This allows the hardware to combine requests into fewer memory transactions.

Poor memory patterns cause memory divergence and lower bandwidth efficiency.

## Latency Bound

A workload is latency bound when execution frequently stalls waiting for events such as:

- Memory fetch completion
- Synchronization
- Communication

Even if bandwidth is sufficient, high-latency operations can slow execution.  Typical indicators:

- High stall cycles
- Low hardware utilization
- Frequent synchronization waits

### Key Terms

**Stall**

A stall occurs when execution units cannot proceed because required data or resources are unavailable.

Examples include:

- Memory dependency stall
- Execution dependency stall
- Synchronization Overhead
- Synchronization overhead occurs when threads must wait for each other.

Common sources include:

- Locks
- Barriers
- Atomic operations
- False Sharing

False sharing occurs when multiple cores modify variables located within the same cache line.  The cache line repeatedly moves between cores, causing excessive cache coherence traffic.

**NUMA Remote Access**

In multi-socket systems, accessing memory attached to another CPU socket increases latency.  Example data path:

```bash
CPU0 → inter-socket fabric → CPU1 → DRAM
```

This introduces additional latency compared to local memory access.

**Communication Latency**

In distributed or multi-device systems, communication delays can limit performance.  Examples include:

- Network latency
- PCIe transfer latency
- GPU collective operations such as AllReduce

**Bottlenecks**

A bottleneck is the system resource that limits overall performance.  Examples include:

- Bottleneck Type	Description
- Compute Bottleneck	Arithmetic units fully utilized
- Memory Bottleneck	Memory bandwidth exhausted
- Latency Bottleneck	Execution frequently stalls
- Communication Bottleneck	Data transfer limits scaling
- Synchronization Bottleneck	Threads waiting on locks or barriers
- Practical Performance Diagnosis

Performance engineers typically follow these steps:

- Measure hardware utilization
- Identify stall reasons
- Determine the performance regime

Diagnostic questions include:

- Is IPC low?
- Are cache miss rates high?
- Is memory bandwidth saturated?
- Are threads waiting on synchronization?

These observations help determine whether the workload is:

- Compute Bound
- Memory Bound
- Latency Bound

## Optimization Strategies

Once the regime is identified, optimization strategies become clearer.

| Regime        | Typical Optimization Strategy                                   |
|---------------|------------------------------------------------------------------|
| Compute Bound | Improve algorithm efficiency, vectorization, or parallelism     |
| Memory Bound  | Improve locality, reduce memory traffic                         |
| Latency Bound | Increase parallelism or hide latency                            |
