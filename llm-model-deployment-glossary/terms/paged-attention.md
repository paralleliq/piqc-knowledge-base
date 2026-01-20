## Paged Attention

**Definition**  
A memory management technique that stores KV cache in fixed-size blocks (pages) and dynamically maps them to active sequences, instead of allocating contiguous memory per request.

**Why it exists**  
Traditional contiguous KV cache allocation leads to severe memory fragmentation and wasted space. Paged attention improves memory utilization and enables higher concurrency and longer context lengths.

**Where in the stack**  
Execution layer / Memory management

**Key properties**
- Allocates KV cache in fixed-size blocks (pages)  
- Allows non-contiguous physical memory for a single sequence  
- Enables efficient sharing and reuse of memory blocks  
- Reduces fragmentation and improves allocatable capacity  
- Decouples logical sequence layout from physical memory layout  

**Common pitfalls**
- Page size too small increases bookkeeping overhead  
- Page size too large wastes memory for short sequences  
- Poor eviction policies cause memory pressure and stalls  
- Assumptions about contiguous memory no longer hold  
- Debugging becomes harder due to indirection  

**Related terms**
- KV cache  
- Memory fragmentation  
- Active sequences  
- Continuous batching  
- Block allocator  
- vLLM  

**In practice**  
In vLLM, paged attention allows thousands of concurrent sequences by mapping KV cache blocks dynamically, dramatically reducing fragmentation and increasing effective GPU memory utilization.

