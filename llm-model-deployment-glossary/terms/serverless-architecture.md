## Serverless Architecture

**Definition**

An execution model where compute resources are provisioned, scaled, and managed automatically by the platform, and workloads run in ephemeral instances without user-managed servers.

**Why it exists**

Workload demand is highly variable. Serverless abstracts infrastructure management and enables fine-grained scaling and pay-per-use execution.

**Where in the stack**

Control plane / Orchestration layer / Serving layer

**Key properties**
- Instances are created and destroyed dynamically  
- Scaling is automatic and typically request-driven  
- Billing is proportional to execution time or requests  
- Infrastructure is fully managed by the platform  
- Instances are stateless or minimally stateful  

**Common pitfalls**
- Cold start latency dominates for large models  
- Model loading time makes fine-grained scaling impractical  
- GPU provisioning cannot be instantaneous  
- Stateless design conflicts with KV cache and session state  
- Hidden limits on concurrency and memory  

**Related terms**
- Cold start  
- Autoscaling  
- Warm pools  
- Ephemeral instances  
- Stateless serving  
- Scale-to-zero  

**In practice**

For LLM serving, pure serverless architectures struggle due to long model load times and large GPU memory requirements, making pre-warmed capacity and hybrid models more effective than true scale-to-zero designs.

