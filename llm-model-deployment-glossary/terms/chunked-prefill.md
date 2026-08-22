## Chunked Prefill

**Definition**

Splitting a long prompt's prefill computation into smaller pieces processed across multiple scheduling steps, interleaved with ongoing decode work, instead of running the entire prefill in one uninterrupted pass.

**Why it exists**

A single large prefill pass monopolizes the GPU for its full duration, during which decode steps for other concurrently running sequences can't proceed — a long prompt effectively imposes head-of-line blocking on every other active sequence. Chunked prefill breaks the prefill into smaller pieces that can be interleaved with decode steps for other sequences, trading a slightly longer TTFT for that one long-prompt request in exchange for much better throughput and latency consistency for everyone else sharing the GPU.

**Where in the stack**

Execution layer / Scheduling

**Key properties**
- Trades TTFT for the long-prompt request against fairness and throughput consistency for concurrently running sequences
- Requires scheduler support to interleave partial prefill chunks with decode steps rather than treating prefill as an atomic, uninterruptible operation
- Chunk size is a tunable parameter — smaller chunks interleave more finely but add scheduling overhead
- Most valuable in mixed workloads where long-context requests and short, latency-sensitive requests share the same GPU
- Distinct from disaggregated prefill/decode — chunking still runs prefill and decode on the same instance, just no longer as one atomic block

**Common pitfalls**
- Chunk size mistuned for the workload — too large reintroduces the head-of-line blocking chunking is meant to solve; too small adds unnecessary scheduling overhead
- Assuming chunked prefill is free — it does add real TTFT to the long-prompt request itself, which matters if that specific request is latency-sensitive
- Not enabling it for genuinely mixed-length workloads and then observing that short requests suffer p99 latency spikes whenever a long prompt arrives
- Conflating chunked prefill (splitting one instance's prefill into pieces) with disaggregated prefill/decode (splitting prefill and decode across separate instances entirely) — they solve related but distinct problems
- Overlooking that this is a configuration parameter (like `max_num_seqs` or batch size limits) whose effective operating range needs monitoring, not a one-time setting

**Related terms**
- Prefill
- Decode
- Head-of-line blocking
- Continuous batching
- Disaggregated prefill/decode
- TTFT

**In practice**

A deployment serving a mix of short chat requests and long document-summarization prompts on the same GPU sees its chat p99 latency spike every time a long summarization request arrives — enabling chunked prefill lets the summarization prompt's prefill interleave with the chat requests' decode steps instead of blocking them outright.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
