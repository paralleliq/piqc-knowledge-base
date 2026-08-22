## Prefill

**Definition**

The initial phase of inference where the model processes the entire input prompt in one forward pass, computing and caching the key/value attention states for every input token before generation begins.

**Why it exists**

Before the model can generate a single new token, it has to build attention state for everything already in the context — the system prompt, conversation history, retrieved documents, whatever the prompt contains. Doing this in one parallelized pass over all input tokens is far more compute-efficient than processing them one at a time, which is why prefill and decode are treated as distinct phases with different performance characteristics.

**Where in the stack**

Execution layer

**Key properties**
- Processes the full input prompt in a single forward pass, in parallel across tokens
- Compute-bound — cost scales with prompt length, not with time
- Populates the KV cache for every prompt token before the first output token is produced
- Directly determines time to first token (TTFT)
- Separable from decode — disaggregated serving architectures (llm-d, Dynamo) run prefill and decode on different pods or hardware

**Common pitfalls**
- Long prompts create GPU-utilization spikes distinct from decode's steadier profile — capacity planning that averages the two phases together misjudges both
- Prefix caching skips redundant prefill for repeated context, but a low hit rate means paying full prefill cost on every request
- Chunked prefill (splitting a long prompt's prefill across multiple scheduling steps) trades TTFT for better interleaving with decode, and is easy to leave misconfigured for the wrong workload mix
- Prefill and decode have different GPU utilization signatures — a prefill-heavy pod looks "unhealthy" against a decode-calibrated baseline and vice versa
- Retrieval-augmented or long-context workloads can make prefill the dominant cost, not decode, which surprises teams who tuned for decode throughput alone

**Related terms**
- Decode
- KV cache
- Prefix caching
- TTFT
- Chunked prefill
- Disaggregated prefill/decode

**In practice**

TTFT is almost entirely prefill time — a slow first token on a long-context request is a prefill bottleneck, not a decode one, and the fix (chunking, prefix caching, larger GPU tier) is different from what fixes slow token-by-token generation.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
