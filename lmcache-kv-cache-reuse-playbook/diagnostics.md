# Diagnostics: Is Cross-Engine KV Cache Reuse Actually Helping?

This page covers how to check whether LMCache-style cross-engine KV cache
reuse is (a) present, (b) actually being hit, and (c) net-positive once
transport/retrieval cost is accounted for. It does not cover any specific
vendor's detection or recommendation logic — this is general operational
diagnosis, the same as the rest of this knowledge base.

---

## Step 1: Confirm what's actually configured

Before diagnosing behavior, confirm the deployment topology:

- Is cross-engine cache reuse (LMCache or equivalent) actually enabled, or
  is the deployment relying on vLLM's built-in prefix cache alone?
- If enabled, which storage tier(s) is it using — CPU RAM, local disk,
  remote store, or a mix?
- Is this a standard co-located prefill+decode deployment, or a
  disaggregated topology where cache transport between stages is
  mandatory rather than optional?

Getting this wrong first — assuming cross-engine reuse is active when
only the local prefix cache is — is the most common diagnostic mistake.
The symptoms of "reuse isn't happening" and "reuse was never configured"
look identical from the outside.

---

## Step 2: Separate local hit rate from cross-engine hit rate

vLLM's built-in prefix cache hit rate and a cross-engine cache's hit rate
answer different questions, and conflating them hides the real signal:

- **Local prefix cache hit rate** — how often a request reuses cache
  already resident in *this* engine instance's GPU memory
- **Cross-engine hit rate** — how often a request reuses cache that had
  to be *fetched* from another instance or an offload tier

A deployment can have a healthy local hit rate and a near-zero
cross-engine hit rate — meaning the local cache is already capturing
essentially all the real reuse, and the cross-engine layer is adding
complexity and fetch latency for negligible additional benefit.

---

## Step 3: Measure the actual cost of a cache fetch

When cross-engine reuse *is* being hit, confirm it's still a net win:

- What's the added latency of fetching from CPU RAM vs. local disk vs. a
  remote store, compared to just recomputing the KV cache from scratch?
- Is that fetch cost showing up as a measurable tail-latency contributor
  (p95/p99), even if it doesn't move the median?
- For disaggregated prefill-decode topologies specifically: is cache
  transport between stages the dominant contributor to time-to-first-token,
  and if so, is that expected given the network path between the two
  instances?

A cache hit that costs more in fetch latency than a fresh computation
would have cost in compute is a net loss, not a win — this is easy to
miss if only hit rate is tracked and fetch cost never is.

---

## Step 4: Correlate with traffic pattern, not just point-in-time metrics

Shared-prefix structure in traffic is not static. Check whether:

- The traffic pattern that originally justified adopting cross-engine
  reuse (long shared system prompts, heavy multi-turn chat, repeated RAG
  context) is still representative of current traffic
- Load balancing behavior has changed in a way that affects how often
  requests with shared context land on different engine instances
- A recent model or prompt-template change altered how much of the
  prefix is actually shared across requests

A configuration that was clearly justified at rollout can quietly become
dead weight as traffic evolves, with no single point-in-time metric
flagging the drift.

---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
