## Block Allocator

**Definition**

The memory manager responsible for handing out and reclaiming fixed-size KV cache blocks (pages) to active sequences, mapping each sequence's logical token positions onto physical memory blocks that need not be contiguous.

**Why it exists**

Paged attention's whole premise — non-contiguous KV cache storage — needs something to actually track which physical blocks are free, which are assigned to which sequence, and when a block can be reclaimed. The block allocator is that bookkeeping layer, analogous to a virtual memory manager in an operating system.

**Where in the stack**

GPU & Memory

**Key properties**
- Tracks free vs. allocated blocks and assigns them to sequences as they grow token by token
- Reclaims blocks immediately when a sequence finishes or is evicted, making them available to new sequences
- Enables memory sharing between sequences with identical prefixes (the same mechanism prefix caching depends on)
- Block size is a tunable trade-off: smaller blocks reduce internal fragmentation but increase allocator bookkeeping overhead
- Sits directly underneath continuous batching — without fast block allocation/reclamation, sequences can't enter and leave a running batch cheaply

**Common pitfalls**
- Block size mistuned for the workload's typical sequence length wastes memory (too large) or adds overhead (too small)
- Eviction policy choices under memory pressure can silently drop cache for sequences assumed still active, causing recomputation
- Treating the allocator as invisible infrastructure until an eviction storm or fragmentation issue makes it the actual root cause of a throughput cliff
- Debugging KV cache issues without accounting for block-level indirection — the block map, not the logical sequence view, is where allocation failures actually occur
- Assuming allocator behavior is uniform across inference frameworks — block size defaults and eviction policies differ between vLLM, SGLang, and others

**Related terms**
- Paged attention
- KV cache
- Memory fragmentation
- Continuous batching
- Prefix caching
- Cache eviction

**In practice**

In vLLM, the block allocator is what makes paged attention's memory-sharing possible — two requests with an identical system prompt can point at the same physical cache blocks for that shared prefix instead of each holding a separate copy.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
