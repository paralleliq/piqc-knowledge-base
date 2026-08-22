## OpenTelemetry

**Definition**

A vendor-neutral, standardized format and collection framework for exporting metrics, traces, and logs — increasingly the common export layer across inference frameworks (vLLM, SGLang, Triton, TGI) instead of each framework defining its own bespoke metrics endpoint.

**Why it exists**

Every inference framework historically exposed metrics its own way, forcing any monitoring or collection tool to write and maintain a separate integration per framework. OpenTelemetry exists to break that pattern — a single, standardized instrumentation and export format that any compliant framework can emit and any compliant collector can read, regardless of which specific engine is underneath.

**Where in the stack**

Observability (cross-cutting, spans execution/serving/control-plane layers)

**Key properties**
- Standardizes metrics, traces, and logs under one schema and export protocol, rather than framework-specific formats
- Growing adoption across vLLM, SGLang, Triton, and TGI as their common export layer, though framework-specific metrics still coexist alongside it in most current deployments
- Enables a single collector implementation to work across multiple inference frameworks, instead of a dedicated collector per framework
- Distinguishes between metrics (aggregated numeric signals), traces (per-request execution paths), and logs — useful for different classes of debugging and monitoring
- The long-term collection strategy for any tool that needs to support a growing and fragmenting set of inference frameworks

**Common pitfalls**
- Assuming OpenTelemetry adoption is complete across all frameworks today — coverage and metric-naming consistency still vary significantly between engines
- Building a collector against OpenTelemetry alone and missing framework-specific signals (like vLLM's KV cache metrics) that haven't been standardized into OTel schemas yet
- Treating OTel-based metrics as a drop-in replacement for framework-native metrics before verifying the specific signals a rule or dashboard depends on are actually exported that way
- Underestimating the value of OTel adoption as a strategic lever — a framework-agnostic collector is significantly cheaper to maintain than one per framework as the ecosystem grows
- Not accounting for trace-level detail (request-scoped, not just aggregate) when OTel tracing could answer a debugging question aggregate metrics can't

**Related terms**
- SGLang
- Triton Inference Server
- DCGM
- vLLM
- TGI
- Observability

**In practice**

As SGLang, Triton, and TGI adoption grows alongside vLLM, a collector built against OpenTelemetry rather than any single framework's native metrics endpoint avoids having to write and maintain a separate integration for each new engine that shows up in a customer's cluster.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
