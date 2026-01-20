## KV Cache

**Definition**  
GPU memory used to store attention keys and values for all active sequences during autoregressive decoding.

**Why it exists**  
Recomputing attention over past tokens is prohibitively expensive. KV cache enables fast incremental generation by reusing previously computed attention states.

**Where in the stack**  
Execution layer

**Key properties**
- Grows with number of active sequences  
- Grows with sequence length (context length)  
- Allocated directly in GPU HBM  
- Dominates memory footprint for long-context models  
- Persists for the lifetime of an active request  

**Common pitfalls**
- Unbounded growth causes GPU out-of-memory (OOM)  
- High memory utilization with low compute utilization  
- Fragmentation prevents reuse and placement of new requests  
- Long-context requests starve short ones  
- Often invisible in standard GPU utilization metrics  

**Relat**

