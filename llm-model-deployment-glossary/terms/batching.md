## Batching

**Definition**

Combining multiple inference requests into a single execution step to improve GPU utilization and throughput.

**Why it exists**

Individual LLM requests are too small to efficiently occupy modern GPUs. Batching amortizes kernel launches and memory access across many requests.

**Where in the stack**

Execution layer / Serving layer

**Key properties**
- Increases throughput by sharing compute across requests  
- Trades latency for efficiency (larger batches → higher latency)  
- Can be static (fixed batch size) or dynamic / continuous  
- Strongly interacts with memory usage and KV cache growth  
- Determines effective GPU occupancy  

**Common pitfalls**
- Large batches cause tail-latency explosions  
- Memory-bound models OOM before compute saturates  
- Batch size tuned for prefill but wrong for decode  
- Mixing long and short sequences creates stragglers  
- Autoscaling signals distorted by batching effects  

**Related terms**
- Continuous batching  
- Prefill  
- Decode  
- Admission control  
- Queue depth  
- Throughput vs latency  

**In practice**

In vLLM and TGI, continuous batching improves throughput but can rapidly increase KV cache pressure if admission is not controlled.

