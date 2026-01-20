## Cold Start

**Definition**  
The delay incurred when a new model instance must be created and initialized before it can serve requests.

**Why it exists**  
Scaling up requires provisioning resources, starting processes, loading model weights, and initializing GPU memory before traffic can be handled.

**Where in the stack**  
Control plane / Serving layer / Execution layer

**Key properties**
- Includes pod scheduling, container startup, and model loading  
- Dominated by weight loading and GPU memory initialization  
- Can range from seconds to minutes for large models  
- Blocks autoscaling effectiveness under bursty traffic  
- Often invisible to standard latency metrics until failures occur  

**Common pitfalls**
- Reactive autoscaling arrives after traffic spike has already degraded latency  
- Large models cannot be started fast enough to absorb bursts  
- GPU fragmentation prevents new replicas from placing  
- Cold starts trigger request timeouts and cascading retries  
- Health checks pass before the model is actually warm  

**Related terms**
- Autoscaling  
- Warm pools  
- Model loading  
- Readiness probe  
- Burst traffic  
- Scale-up latency  

**In practice**  
For 70B-class models, cold start time is often dominated by loading tens of gigabytes of weights, making reactive autoscaling ineffective without pre-warmed capacity.

