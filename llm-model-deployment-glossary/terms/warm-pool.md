## Warm Pool

**Definition**  
A set of pre-provisioned and partially initialized instances kept ready to rapidly serve traffic or host new model replicas without incurring full cold start latency.

**Why it exists**  
Cold starts for large models are expensive and slow. Warm pools provide immediate capacity to absorb traffic bursts and scale events while avoiding model load and GPU initialization delays.

**Where in the stack**  
Control plane / Orchestration layer / Provisioning layer

**Key properties**
- Instances are pre-allocated but may be idle or lightly loaded  
- Often have GPUs attached and runtime processes started  
- Can hold loaded models or only initialized environments  
- Trades steady idle cost for reduced scale-up latency  
- Enables burst handling without violating latency SLOs  

**Common pitfalls**
- Over-provisioning wastes expensive GPU capacity  
- Pools sized statically fail under changing demand patterns  
- Models in pool become stale or misconfigured  
- Warm capacity not aligned with actual placement constraints  
- Hidden fragmentation prevents rapid allocation  

**Related terms**
- Cold start  
- Autoscaling  
- Serverless architecture  
- Pre-warmed instances  
- Scale-up latency  
- Provisioning latency  

**In practice**  
In GPU-based LLM serving, warm pools are often required to meet latency SLOs because loading large models on demand takes tens of seconds to minutes, making reactive autoscaling ineffective.

