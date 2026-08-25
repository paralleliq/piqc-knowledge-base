## Admission Caps

**Definition**

The two independent configuration limits — a sequence-count cap and a token-budget cap — that bound how much concurrent work a serving engine's scheduler will admit into a single batch at each step.

**Why it exists**

A serving engine needs a hard ceiling on how much work to admit per step, or it would pack in whatever memory allows and risk OOM under a burst. A single count-based cap isn't enough on its own: a batch of few but very long sequences can be just as expensive as a batch of many short ones. Two independent caps — one on sequence count, one on total tokens — are needed to bound both dimensions.

**Where in the stack**

Scheduling & Admission

**Key properties**
- vLLM's concrete implementation: `max_num_seqs` (sequence-count cap) and `max_num_batched_tokens` (token-budget cap), evaluated independently at every scheduling step
- Whichever cap binds first is what's actually limiting admission — a deployment can be far under its sequence-count cap and still be throttled by the token-budget cap, e.g. a few long-context requests filling the token budget
- The token-budget cap matters most during prefill, where a single long prompt can consume most of a step's token budget by itself
- Raising either cap admits more concurrent work — more throughput headroom, but also more KV cache pressure per step
- Distinct from KV cache headroom itself: these are configured ceilings, not memory-based limits, though a badly-tuned cap can strand a deployment that's memory-safe but throughput-starved, or the reverse

**Common pitfalls**
- Checking only the sequence-count cap when diagnosing throttling and missing a deployment that's actually bound by the token-budget cap instead
- Setting the token-budget cap without accounting for the workload's real prompt-length distribution, so a handful of long-context requests silently starve the rest
- Raising `max_num_seqs` to fix apparent underutilization when the real ceiling is `max_num_batched_tokens`, which does nothing to relieve it
- Setting both caps generously without validating KV cache headroom actually supports them under real traffic, trading an admission bottleneck for an OOM or thrashing one
- Treating these as a one-time launch flag rather than something to revisit as traffic patterns — average sequence length, burstiness — change

**Related terms**
- Admission control
- Continuous batching
- Effective batch size
- KV cache
- Chunked prefill
- Active sequences

**In practice**

A deployment can show low GPU utilization and requests queueing at the same time — not because of the GPU, but because `max_num_seqs` or `max_num_batched_tokens`, whichever binds first, is capping admission below what the hardware could actually serve. Raising the binding one, not adding replicas, is the fix.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
