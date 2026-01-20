## Prefix Caching

**Definition**  
A technique that reuses previously computed KV cache for shared input prefixes across multiple requests to avoid redundant computation and memory allocation.

**Why it exists**  
Many LLM workloads share common prefixes (system prompts, templates, retrieved context). Recomputing attention for identical prefixes wastes compute and KV cache capacity.

**Where in the stack**  
Execution layer / Memory management / Serving layer

**Key properties**
- Caches KV cache for common prompt prefixes  
- Eliminates repeated prefill computation for shared context  
- Reduces latency for repeated or templated prompts  
- Reduces KV cache growth for overlapping requests  
- Requires prefix hashing and cache lookup mechanisms  

**Common pitfalls**
- Cache invalidation errors cause incorrect generation  
- Large prefixes consume significant persistent memory  
- Low hit rates provide little benefit but add overhead  
- Prefix diversity in real traffic limits effectiveness  
- Hard to integrate with dynamic batching and eviction policies  

**Related terms**
- KV cache  
- Prefill  
- Decode  
- Prompt templates  
- RAG  
- Cache eviction  

**In practice**  
In chat and RAG systems, prefix caching can reuse system prompts and retrieved context across sessions, significantly reducing prefill latency and KV cache pressure when hit rates are high.

