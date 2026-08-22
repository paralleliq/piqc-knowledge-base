## Decode

**Definition**

The phase of inference that generates output tokens one at a time, each step reading the growing KV cache to attend over the prompt and every token generated so far.

**Why it exists**

Autoregressive generation is inherently sequential: each new token depends on every token before it, including ones the model just produced. Decode is where that sequential dependency plays out, one forward pass per output token, which makes it fundamentally different in cost profile from prefill's fully parallel single pass over the prompt.

**Where in the stack**

Execution layer

**Key properties**
- Produces exactly one new token per forward pass, per sequence
- Memory-bandwidth-bound rather than compute-bound — reading the KV cache dominates cost, not FLOPs
- KV cache grows by one entry per token, per sequence, for the duration of decode
- Directly determines TPOT (time per output token) and overall generation latency
- Batches many concurrent sequences' decode steps together to amortize memory-bandwidth cost — the entire rationale for continuous batching

**Common pitfalls**
- Treating decode as compute-bound and trying to fix slow generation with more FLOPs rather than more memory bandwidth or a smaller per-token memory footprint
- Long sequences make decode increasingly memory-bandwidth-heavy as the KV cache grows, degrading TPOT gradually rather than failing outright
- Techniques that add per-step overhead (beam search, self-speculative heads) trade decode throughput for output quality or multi-token gains, and require decode-step accounting to reason about correctly
- Speculative decoding overlaps multiple candidate decode steps into one verification pass — useful, but easy to misattribute utilization if the fact schema doesn't track it
- Confusing decode-phase GPU idle time (waiting on memory) with genuine underutilization from too few concurrent requests

**Related terms**
- Prefill
- KV cache
- TPOT
- Continuous batching
- Speculative decoding
- Autoregressive decoding

**In practice**

TPOT is a decode-phase metric — a deployment with fast TTFT but slow TPOT has efficient prefill and a decode-side bottleneck, typically KV cache growth outrunning available memory bandwidth as concurrent sequences accumulate.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
