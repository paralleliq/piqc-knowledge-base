## TGI (Text Generation Inference)

**Definition**

HuggingFace's inference serving engine for LLMs, common in HuggingFace-native deployment pipelines, exposing its own `/metrics` endpoint distinct from vLLM's or Triton's.

**Why it exists**

Teams whose model development and deployment workflow is built around the HuggingFace ecosystem (Hub, Transformers, Inference Endpoints) often standardize on TGI as the natural serving layer, since it integrates directly with HuggingFace model artifacts and tooling without requiring a separate conversion or export step to another framework's format.

**Where in the stack**

Serving layer

**Key properties**
- Native integration with HuggingFace Hub model artifacts, minimizing friction for teams already in that ecosystem
- Exposes its own `/metrics` endpoint with framework-specific naming, separate from vLLM's or Triton's metrics surface
- Supports continuous-batching-style scheduling and quantization, similar in spirit to vLLM's approach but implemented independently
- Common among HuggingFace-native enterprise accounts specifically, rather than a general default across all inference deployments
- Lower current adoption priority than vLLM or SGLang for most fact-collection roadmaps, but relevant wherever a customer's stack is HuggingFace-centric

**Common pitfalls**
- Assuming vLLM-style metric names or KV cache fact keys map directly onto TGI's `/metrics` output — they don't, and require their own mapping
- Deprioritizing TGI collector support entirely and then discovering a HuggingFace-native enterprise customer whose entire fleet is invisible without it
- Treating TGI as functionally identical to vLLM in configuration and tuning behavior, when scheduling and batching defaults differ between the two
- Missing TGI-specific quantization or batching configuration opportunities by only checking for vLLM-style optimization signals
- Not accounting for TGI when scoping a framework-agnostic (OpenTelemetry-based) collection strategy, since it's one more surface that needs coverage

**Related terms**
- vLLM
- SGLang
- Triton Inference Server
- OpenTelemetry
- Continuous batching
- Quantization

**In practice**

A HuggingFace enterprise customer running TGI end-to-end from Hub model artifacts to serving needs a dedicated collector reading TGI's own `/metrics` endpoint — treating it as "close enough" to vLLM misses both the metric-name differences and TGI-specific optimization opportunities.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
