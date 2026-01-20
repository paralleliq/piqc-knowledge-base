## TTFT (Time To First Token)

**Definition**  
The elapsed time from when a request is received until the first output token is generated and returned to the client.

**Why it exists**  
Users perceive responsiveness based on how quickly the model begins responding. TTFT captures the combined cost of queueing, scheduling, prefill, and model readiness.

**Where in the stack**  
Serving layer / Execution layer / End-to-end latency

**Key properties**
- Includes queueing delay, scheduling, and prefill computation  
- Dominated by prompt length and model size  
- Highly sensitive to batching and admission control  
- Strongly affected by cold starts and model loading  
- Primary driver of perceived interactivity  

**Common pitfalls**
- Optimizing TPOT while TTFT remains high  
- Large batches dramatically inflate TTFT  
- Ignoring queueing delay in autoscaling decisions  
- Cold starts cause extreme TTFT spikes  
- Health checks pass while TTFT is already violating SLOs  

**Related terms**
- Prefill  
- Cold start  
- Batching  
- Queueing delay  
- Tail latency  
- TTBT (Time To Begin Token)  

**In practice**  
In chat systems, high TTFT is often caused by long prompts, batch formation delays, or cold starts, making the system feel unresponsive even when throughput is high.

