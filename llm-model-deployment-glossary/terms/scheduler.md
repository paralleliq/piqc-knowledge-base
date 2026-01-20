## Scheduler

**Definition**  
A component responsible for selecting, ordering, and dispatching inference requests onto execution resources according to policy and resource constraints.

**Why it exists**  
Multiple requests compete for limited GPU compute and memory. The scheduler determines which requests run, when they run, and how they are batched to balance latency, throughput, and resource utilization.

**Where in the stack**  
Execution layer / Serving layer

**Key properties**
- Controls request admission and execution order  
- Forms and manages batc

