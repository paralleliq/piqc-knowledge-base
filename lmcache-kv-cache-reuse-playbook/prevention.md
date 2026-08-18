# Prevention Checklist: Adopting Cross-Engine KV Cache Reuse Correctly

A checklist for deciding whether to adopt LMCache-style cross-engine KV
cache reuse, and for keeping it healthy if you do. General operational
guidance — not tied to any specific vendor's implementation or
recommendation logic.

---

## Before adopting

- [ ] Measure actual shared-prefix structure in production traffic —
      don't adopt cross-engine reuse speculatively, based on how the
      workload is *expected* to behave
- [ ] Confirm requests with shared context are actually being routed to
      *different* engine instances — if load balancing happens to keep
      related requests on the same instance, the built-in prefix cache
      alone may already capture the available reuse
- [ ] Benchmark fetch latency for each storage tier under consideration
      (CPU RAM / local disk / remote store) against the cost of simply
      recomputing the KV cache — reuse only wins if fetch is meaningfully
      cheaper than recompute
- [ ] For disaggregated prefill-decode topologies, treat cache transport
      as a mandatory, first-class part of the latency budget from day
      one, not something to benchmark after the fact

---

## Once adopted

- [ ] Track cross-engine cache hit rate separately from the local,
      in-GPU-memory prefix cache's own hit rate — they answer different
      questions and averaging them together hides both signals
- [ ] Track fetch latency from the offload tier as its own metric, not
      just overall request latency — a rising fetch-latency trend can
      erode the benefit long before it shows up as an obvious regression
- [ ] Re-validate the original shared-prefix assumption periodically —
      traffic patterns, prompt templates, and routing behavior all drift
      over time
- [ ] When retiring or downsizing a deployment, explicitly revisit
      whether cross-engine reuse is still justified at the new scale —
      what earned its overhead at high replica count may not at low
      replica count

---

## Red flags worth investigating directly

- Cross-engine hit rate near zero while local prefix cache hit rate is
  healthy — the added system may not be earning its complexity
- Offload-tier fetch latency showing up as a real contributor to p95/p99
  request latency
- No one can explain, from current traffic data, why cross-engine reuse
  was adopted in the first place — a sign the original justification may
  no longer hold

---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
