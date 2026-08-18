# LMCache & Cross-Engine KV Cache Reuse (vLLM)

This playbook covers a different failure mode than the [KV Cache Pressure
Playbook](../kv-cache-pressure-playbook/): not "the KV cache is crashing
your pods," but **"you're paying to recompute a KV cache you already
computed somewhere else."**

> **Applies wherever vLLM's built-in prefix cache is the only cache in play.**
>
> vLLM's native prefix cache is fast, but scoped to a single engine instance
> and GPU memory only. LMCache extends the same idea — reuse KV cache
> instead of recomputing it — across engine instances and across storage
> tiers (CPU RAM, local disk, remote store). Everything below is general
> to that class of system, not specific to any one deployment.

---

## What this playbook covers

- What LMCache actually is, and how it differs from vLLM's built-in prefix cache
- When it helps, and when it's a solution looking for a problem
- Signs you're leaving reuse opportunity on the table
- Signs it's enabled but not actually earning its overhead
- How to verify it's working, not just running

This guide is written for ML engineers, platform teams, and SREs operating
LLM inference in production — not for Paralleliq's platform users
specifically. It doesn't cover any detection thresholds, rule logic, or
recommendation engine behavior; it's the same conceptual, mental-model
treatment as the rest of this knowledge base.

---

## Mental model

vLLM's built-in prefix cache reuses KV cache **within one engine
instance**, for requests that share an identical token prefix (e.g. the
same system prompt). It lives in GPU memory only, and it disappears the
moment that engine instance evicts it or restarts.

**LMCache generalizes the same idea in two directions at once:**

1. **Across engine instances** — a KV cache computed by one vLLM replica
   can be reused by a different replica, instead of every replica
   recomputing the same shared context independently.
2. **Across storage tiers** — instead of "in GPU memory or gone," cache
   can be offloaded to CPU RAM, local disk, or a remote store, and pulled
   back in when needed. That trades some latency for a much larger
   effective cache than GPU memory alone could ever hold.

The same underlying idea also shows up in **prefill-decode disaggregation**
architectures, where prefill and decode run on separate engine instances
(sometimes separate hardware entirely) — the KV cache computed during
prefill has to be transferred to the decode instance rather than reused
in place. Cross-engine cache transport is the same mechanical problem
either way.

---

## When it actually helps

LMCache-style reuse pays off when there's real, repeated shared context
**across requests that don't all land on the same engine instance**:

- Long, shared system prompts across many users (support bots, coding
  assistants with a large fixed instruction set)
- Multi-turn chat where the growing conversation history would otherwise
  be recomputed on every turn if load balancing sends turns to different
  replicas
- RAG pipelines where the same retrieved document chunks show up across
  many different user queries
- Prefill-decode disaggregated deployments, where cache transport between
  stages is mandatory, not optional

It does **not** help — and adds pure overhead — when traffic is mostly
one-off, low-shared-prefix requests (the same failure mode that limits
vLLM's own prefix cache, see the [GPU Utilization Interpretation
Guide](../gpu-utilization-interpretation-guide/)), or when all traffic
already lands on a single engine instance with GPU memory to spare — in
that case the built-in prefix cache already captures the available reuse,
and the added storage/network hop is only downside.

---

## Signs you're missing an opportunity

You may be leaving real reuse on the table if:

- Traffic has a genuinely long, shared prefix (system prompt, RAG context,
  conversation history) **but** requests are load-balanced across
  multiple engine replicas
- You're running a prefill-decode disaggregated topology and cache
  transport between stages is a hand-rolled or ad-hoc mechanism
- GPU-memory-only prefix cache hit rate is low specifically because the
  cache keeps getting evicted under memory pressure, not because the
  traffic lacks shared structure

👉 Cross-reference: the [KV Cache Pressure
Playbook](../kv-cache-pressure-playbook/) if the second case above looks
familiar — the two often show up together.

---

## Signs it's enabled but not earning its overhead

The opposite failure mode: LMCache (or an equivalent cross-engine cache)
is running, but adding cost and complexity without a real reuse payoff.
Look for:

- Cache hit rate for the *cross-engine* path is low or near zero, while
  the local, in-GPU-memory prefix cache alone would have captured most of
  the actual reuse
- Retrieval latency from the offload tier (disk / remote store) is
  showing up as a measurable fraction of end-to-end request latency —
  the reuse savings are being partially or fully offset by fetch cost
- Traffic pattern has shifted (e.g. away from long shared system prompts)
  since the cache was configured, and nobody revisited whether it's still
  earning its keep

👉 Diagnostics: [`diagnostics.md`](./diagnostics.md)

---

## Preventing both failure modes

- Measure shared-prefix structure in real traffic *before* adopting
  cross-engine reuse — don't add it speculatively
- Track cache hit rate for the cross-engine/offload path specifically,
  separate from the local GPU-memory prefix cache's own hit rate
- Revisit the decision when traffic patterns change — a cache that earned
  its overhead six months ago may not today
- For disaggregated prefill-decode topologies, treat cache transport as a
  first-class latency budget item, not an afterthought

👉 Prevention checklist: [`prevention.md`](./prevention.md)

---

## 🔗 Related Checklists & Guides

- **KV Cache Pressure & GPU OOM in vLLM**
  [`kv-cache-pressure-playbook/`](../kv-cache-pressure-playbook/)

- **GPU Utilization Interpretation Guide**
  [`gpu-utilization-interpretation-guide/`](../gpu-utilization-interpretation-guide/)

- **vLLM Runtime Metrics & Observability Guide**
  [`vllm-runtime-metrics-and-observability-guide/`](../vllm-runtime-metrics-and-observability-guide/)

- **GenAI Model Deployment Checklist**
  [`/CHECKLIST.md`](../CHECKLIST.md)

---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
