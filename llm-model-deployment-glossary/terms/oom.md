## Out of Memory (OOM)

**Definition**  
A failure condition where a process or GPU cannot allocate additional memory because available memory is exhausted or fragmented.

**Why it exists**  
LLM inference requires large, dynamic memory allocations for weights, activations, and KV cache. When demand exceeds available contiguous memory, allocation fails and the process is terminated.

**Where in the stack**  
Execution layer / Hardware layer / Runtime

**Key properties**
- Triggered by model loading, KV cache growth, or large batches  
- Can be hard (process killed) or soft (allocation failure, degraded behavior)  
- Often sudden and non-recoverable at the process level  
- Strongly influenced by fragmentation and allocation strategy  
- Frequently causes pod or container restarts  

**Common pitfalls**
- Confusing compute saturation with memory exhaustion  
- Scaling replicas without sufficient free GPU memory  
- Ignoring fragmentation and reserved memory pools  
- Assuming utilization metrics reflect allocatable memory  
- Repeated OOMs cause cascading cold starts and instability  

**Related terms**
- KV cache  
- Memory fragmentation  
- GPU HBM  
- Model loading  
- Cold start  
- Pod restart  

**In practice**  
In LLM serving, OOM often occurs when KV cache grows faster than expected, leading to sudden pod restarts even when GPU compute utilization appears low.

