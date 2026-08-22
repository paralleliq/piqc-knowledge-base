## Beam Search

**Definition**

A decoding strategy that keeps multiple candidate sequences ("beams") alive in parallel at each step, scoring their extensions and pruning to the top-k, instead of committing to a single token per step.

**Why it exists**

Greedy or sampled decoding commits to one token at a time and can lock in a locally good but globally poor sequence. Beam search explores several candidate continuations simultaneously and keeps the highest-scoring ones, improving output quality for tasks like translation or structured generation where the best sequence isn't always the greedy one.

**Where in the stack**

Execution layer / Decoding strategy

**Key properties**
- Maintains `beam_width` candidate sequences per request instead of one
- KV cache and compute per request scale roughly linearly with beam width
- Each step scores all beam extensions before pruning back to the top-k
- Improves output quality on tasks sensitive to early token choices
- Distinct from speculative decoding — no draft model, no verification step; every beam is a fully-fledged candidate scored by the same model

**Common pitfalls**
- A beam width of 4 consumes roughly 4x the KV cache and compute of greedy decoding for the same request, but this cost is easy to miss when only counting requests
- Throughput and KV-cache-per-request baselines calibrated for greedy or sampled decoding read as unexpectedly low or high once beam search is active
- Combines poorly with tight batching budgets — beam width effectively multiplies concurrent sequence count
- Latency-sensitive workloads rarely benefit enough to justify the extra compute
- Easy to leave a large beam width configured long after the quality gain has been validated as negligible

**Related terms**
- Speculative decoding
- Self-speculative decoding
- Sampling
- KV cache
- Active sequences
- Decode

**In practice**

A service running beam width 4 shows roughly 4x the per-request KV cache footprint and compute of a greedy-decoding deployment serving the same model — capacity planning and throughput baselines built around greedy decoding will consistently underestimate resource needs unless decoding strategy is tracked as a fact.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
