## TPOT (Time Per Output Token)

**Definition**

The average time required to generate a single output token during decoding, typically measured in milliseconds per token.

**Why it exists**

End-to-end latency is dominated by token generation speed. TPOT provides a fine-grained measure of decoding efficiency independent of prompt length or total response size.

**Where in the stack**

Execution layer / Decoding performance

**Key properties**
- Measures steady-state decoding speed  
- Inversely related to tokens-per-second throughput  
- Strongly influenced by batching, parallelism, and scheduler behavior  
- Sensitive to memory pressure and KV cache state  
- Often stable within a run but degrades under contention  

**Common pitfalls**
- Averaging hides tail behavior and stalls  
- Ignoring prefill time when interpreting user latency  
- Assuming TPOT scales linearly with batch size  
- Overlooking communication overhead in tensor parallelism  
- Using aggregate latency instead of per-token metrics  

**Related terms**
- Tokens per second (TPS)  
- Decode  
- Tail latency  
- Throughput  
- Speculative decoding  
- Scheduler  

**In practice**

In LLM serving, rising TPOT is often the first signal of memory pressure, scheduler contention, or communication bottlenecks before visible throughput collapse or OOM events.

