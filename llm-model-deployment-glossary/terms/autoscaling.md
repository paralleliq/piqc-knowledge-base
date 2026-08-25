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
- Two distinct scaling layers in inference serving, easy to conflate: *replica-level* (adding/removing whole GPU instances — the only layer that changes GPU spend) and *request-level* (packing more concurrent sequences onto an already-running replica, e.g. continuous batching) — a replica sitting at 90% GPU utilization from good request-level packing needs no autoscaling action at all  
- **Reactive vs. predictive:** reactive autoscaling waits for a demand signal to cross a threshold before acting; predictive autoscaling forecasts demand ahead of time and pre-scales to avoid the cold-start window entirely. Most production autoscalers today are reactive — predictive scaling needs a reliable historical-demand model, which most teams don't have running  
- **KEDA** (Kubernetes Event-Driven Autoscaling) is the most common real-world implementation for GPU workloads — extends Kubernetes' native HPA to scale on custom/external metrics (queue depth, request rate, Prometheus queries) instead of just CPU/memory, which plain HPA can't do  

**Common pitfalls**
- Scaling on GPU utilization alone leads to wrong decisions  
- Scale-up latency causes cold-start outages under bursty traffic  
- Memory-bound models scale poorly even when compute is idle  
- Thrashing when scale-up and scale-down oscillate  
- Autoscaler typically triggers on queue depth or request rate, not KV cache, context length, or precision — not because it structurally can't (KEDA will scale on any Prometheus query, including model-exported metrics like `gpu_cache_usage_perc`), but because someone has to manually decide that's the right signal and wire it in per deployment; most setups don't  
- Conflating request-level and replica-level scaling — tuning continuous-batching/admission settings when the actual bottleneck is too few replicas, or vice versa  

**Related terms**
- Horizontal Pod Autoscaler (HPA)  
- KEDA  
- Vertical scaling  
- Admission control  
- Continuous batching  
- Warm pools  
- Predictive scaling  
- Cold start  

**In practice**

In LLM serving, reactive autoscaling often arrives too late; by the time latency rises, GPU memory is already saturated and new replicas cannot be placed.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
