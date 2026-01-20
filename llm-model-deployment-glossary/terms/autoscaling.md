## Autoscaling

**Definition**  
Automatically adjusting the number or size of running model instances based on workload demand or system signals.

**Why it exists**  
Workloads are variable. Autoscaling prevents under-provisioning (high latency, dropped requests) and over-provisioning (idle GPUs, wasted cost).

**Where in the stack**  
Control plane / Orchestration layer

**Key properties**
- Reacts to demand signals (QPS, latency, concurrency, queue depth, GPU metrics)  
- Can scale replicas, pods, or entire GPU nodes  
- Operates with delay (scale-up time is non-zero)  
- Strongly coupled to batching, memory usage, and admission control  

**Common pitfalls**
- Scaling on GPU utilization alone leads to wrong decisions  
- Scale-up latency causes cold-start outages under bursty traffic  
- Memory-bound models scale poorly even when compute is idle  
- Thrashing when scale-up and scale-down oscillate  
- Autoscaler unaware of KV cache, context length, or precision  

**Related terms**
- Horizontal Pod Autoscaler (HPA)  
- Vertical scaling  
- Admission control  
- Warm pools  
- Predictive scaling  
- Cold start  

**In practice**  
In LLM serving, reactive autoscaling often arrives too late; by the time latency rises, GPU memory is already saturated and new replicas cannot be placed.

