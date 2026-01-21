## Scheduler

**Definition**

A component responsible for selecting, ordering, and dispatching inference requests onto execution resources according to policy and resource constraints.

**Why it exists**

Multiple requests compete for limited GPU compute and memory. The scheduler determines which requests run, when they run, and how they are batched to balance latency, throughput, and resource utilization.

**Where in the stack**

Execution layer / Serving layer

**Key properties**
- Controls request admission and execution order  
- Forms and manages batches or micro-batches  
- Tracks active sequences and resource availability  
- Enforces fairness, priority, or latency policies  
- Strongly influences tail latency and throughput  

**Common pitfalls**
- FIFO scheduling causes head-of-line blocking  
- Ignoring memory state leads to OOM and stalls  
- Mixing long and short requests creates stragglers  
- Scheduler unaware of KV cache pressure or fragmentation  
- Policy tuned for throughput but breaks latency SLOs  

**Related terms**
- Admission control  
- Continuous batching  
- Active sequences  
- Queue depth  
- Tail latency  
- Fair scheduling  

**In practice**

In vLLM, the scheduler continuously admits and batches new requests based on available KV cache blocks and active sequence capacity to maximize throughput without triggering memory exhaustion.
