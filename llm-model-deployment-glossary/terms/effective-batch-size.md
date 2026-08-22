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
- The real driver of GPU utilization — a low effective batch size against a high configured max indicates either low traffic or an admission bottleneck, not necessarily healthy operation
- Distinct from active sequence count only in framing: active sequences describes what's running; effective batch size describes it as a utilization metric against capacity
- A key diagnostic for distinguishing genuine low traffic from a scheduler or admission misconfiguration artificially capping concurrency

**Common pitfalls**
- Assuming a configured max batch size reflects real throughput capacity when effective batch size never approaches it under actual traffic patterns
- Sizing GPU capacity around the configured maximum rather than the observed effective batch size under representative load
- Not distinguishing "low effective batch size because traffic is genuinely low" from "low effective batch size because admission control or KV cache headroom is constraining it" — the fixes are opposite
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

A deployment configured for a max batch size of 256 but observed running an effective batch size of 40 under normal traffic isn't necessarily underutilized by design — it's worth checking whether admission control or KV cache headroom, not traffic volume, is the actual ceiling.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
