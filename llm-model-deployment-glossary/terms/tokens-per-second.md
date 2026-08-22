## Tokens Per Second (TPS)

**Definition**

The rate at which a deployment generates output tokens, measured either per individual sequence or aggregated across all concurrently served sequences.

**Why it exists**

Request-per-second doesn't capture cost or capacity meaningfully for LLM workloads, since a request generating 50 tokens and one generating 5,000 tokens consume wildly different amounts of GPU time. Tokens per second is the throughput unit that actually corresponds to compute and memory-bandwidth consumption, making it the standard capacity-planning and pricing metric.

**Where in the stack**

Performance & Metrics

**Key properties**
- Meaningful at two very different scopes: per-sequence TPS (how fast one user's stream generates) and aggregate TPS (total system throughput)
- Aggregate TPS is what continuous batching and admission control are tuned to maximize
- Inversely related to per-sequence TPOT — higher aggregate concurrency generally lowers each individual sequence's TPS as memory bandwidth is shared
- The unit most GPU-tier and cost-per-token calculations are built on
- Distinct from TTFT — TPS describes ongoing generation speed, not the delay before the first token

**Common pitfalls**
- Reporting only aggregate TPS hides per-user experience — total throughput can look great while individual streams feel slow
- Comparing TPS across deployments without normalizing for model size, GPU tier, or decoding strategy (beam search, speculative decoding) produces meaningless comparisons
- Treating TPS as a single number rather than a distribution — tail sequences (very long context, low draft-model acceptance) can be far slower than the average suggests
- Optimizing aggregate TPS by pushing concurrency until per-sequence TPS becomes unacceptable for latency-sensitive use cases
- Not accounting for decoding strategy (beam width, speculative decoding acceptance rate) when interpreting a TPS baseline

**Related terms**
- TPOT
- TTFT
- Throughput optimization
- Continuous batching
- Effective batch size
- Decode

**In practice**

A deployment reporting strong aggregate tokens-per-second can still deliver a poor user experience if per-sequence TPS has degraded because concurrency was pushed too high — both numbers need to be tracked, not just the aggregate.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
