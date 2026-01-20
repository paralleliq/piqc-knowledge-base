## Speculative Decoding

**Definition**

A decoding technique where a smaller “draft” model proposes multiple tokens ahead, and a larger “target” model verifies or corrects them to accelerate generation.

**Why it exists**

Autoregressive decoding is inherently sequential and latency-bound. Speculative decoding reduces the number of expensive forward passes of large models while preserving output quality.

**Where in the stack**

Execution layer / Decoding strategy

**Key properties**
- Uses two models: a fast draft model and a slower target model  
- Draft model generates multiple candidate tokens per step  
- Target model verifies tokens in parallel and accepts or rejects them  
- Increases tokens-per-second without changing model quality  
- Effectiveness depends on draft model accuracy  

**Common pitfalls**
- Poor draft model causes frequent rejections and wasted compute  
- Additional memory overhead for running two models  
- Verification cost limits gains at small batch sizes  
- Hard to combine with tight latency SLOs and batching  
- Debugging correctness issues is non-trivial  

**Related terms**
- Autoregressive decoding  
- Prefill  
- Decode  
- Token verification  
- Throughput optimization  
- Draft model  

**In practice**

In high-throughput LLM serving, speculative decoding can significantly increase tokens-per-second when a well-matched draft model is used, but gains diminish when verification overhead dominates.

