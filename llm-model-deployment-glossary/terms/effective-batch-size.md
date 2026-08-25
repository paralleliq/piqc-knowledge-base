## Effective Batch Size

**Definition**

The actual number of sequences a serving engine processes together at a given decode step, as distinct from a configured maximum batch size that traffic or memory limits may prevent the engine from ever reaching.

**Why it exists**

A deployment configured for a max batch size of 256 tells you nothing about how many sequences it's actually running concurrently at any moment — that depends on real-time traffic, KV cache headroom, and admission control decisions. Effective batch size is the number that actually determines GPU utilization and throughput, and it's frequently far below the configured maximum.

**Where in the stack**

Performance & Metrics

**Key properties**
- Varies every decode step under continuous batching, unlike a fixed configuration value
- Bounded above by KV cache headroom, not just the configured max batch size
- The real driver of GPU utilization — but the diagnostic direction is easy to get backwards: effective batch size sitting well below the configured max actually rules out the configured ceiling as the cause, since the deployment isn't even using its own allowance. Only effective batch size sitting at or near the configured max, combined with low GPU utilization, proves the ceiling itself is the binding constraint
- Distinct from active sequence count only in framing: active sequences describes what's running; effective batch size describes it as a utilization metric against capacity
- A key diagnostic for distinguishing genuine low traffic from a scheduler or admission misconfiguration artificially capping concurrency

**Common pitfalls**
- Assuming a configured max batch size reflects real throughput capacity when effective batch size never approaches it under actual traffic patterns
- Sizing GPU capacity around the configured maximum rather than the observed effective batch size under representative load
- Assuming a low effective batch size relative to a generous configured max implicates the admission ceiling — it's the opposite: that pattern rules the ceiling out, since the deployment isn't even reaching its own allowance. What actually implicates the ceiling is effective batch size sitting at or near the configured max while GPU utilization stays low; a low, unconstrained-looking number more often points to genuinely low traffic, or to KV cache headroom capping concurrency below what the configured max would otherwise allow
- Comparing effective batch size across deployments without normalizing for average sequence length, since long sequences mechanically cap effective batch size lower
- Missing that decoding strategies like beam search reduce effective batch size for a given KV cache budget, since each request now consumes multiple beams' worth of cache

**Related terms**
- Active sequences
- Continuous batching
- Admission control
- KV cache
- Tokens per second
- Beam search

**In practice**

A deployment configured for a max batch size of 256 but observed running an effective batch size of 40 isn't a sign the admission ceiling is the problem — running at 40 with headroom up to 256 means the configured max isn't what's blocking it; genuinely low traffic or KV cache headroom are the more likely causes. The pattern that actually implicates the ceiling looks different: effective batch size sitting at, say, 30 against a configured max of 32, with GPU utilization still low — that's when raising the configured max is the fix.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
