## Triton Inference Server

**Definition**

NVIDIA's general-purpose model-serving platform, common in enterprise deployments, that exposes per-model and per-backend statistics through its own metrics surface rather than a single inference-framework-specific API.

**Why it exists**

Many enterprises run a mix of model types and frameworks (not just LLMs) and need one serving layer that can host multiple backends — TensorRT-LLM, ONNX, PyTorch, and others — behind a consistent deployment and management interface. Triton exists to be that common serving layer, standardizing operational concerns (versioning, batching, multi-model hosting) across backends that differ underneath.

**Where in the stack**

Serving layer

**Key properties**
- Backend-agnostic serving layer — can host TensorRT-LLM, ONNX Runtime, PyTorch, and other backends behind one interface
- Exposes its own metrics and management API, distinct from what any individual backend (like vLLM) would expose natively
- Common in enterprise NVIDIA-centric deployments, often paired with TensorRT-LLM as the LLM-serving backend specifically
- Supports dynamic batching and model versioning as first-class serving-platform features, not backend-specific add-ons
- A customer running Triton looks structurally different to monitoring built around vLLM's native surface, even when the underlying model and hardware are similar

**Common pitfalls**
- Assuming vLLM-native fact collection or dashboards transfer to a Triton-fronted deployment — they don't, since Triton's metrics surface is its own
- Conflating Triton (the serving platform) with TensorRT-LLM (the LLM inference engine it commonly hosts as a backend) — they're separate concerns
- Missing backend-specific optimization opportunities (e.g., TensorRT-LLM-specific tuning) by only looking at Triton's platform-level metrics
- Underestimating the collector engineering needed for enterprise accounts standardized on Triton, since the metrics model doesn't map one-to-one onto vLLM-style facts
- Treating multi-backend flexibility as free — different backends behind the same Triton instance can have very different resource profiles that a single monitoring baseline won't capture

**Related terms**
- TensorRT-LLM
- SGLang
- OpenTelemetry
- Batching
- vLLM
- TGI

**In practice**

An enterprise account running TensorRT-LLM models behind Triton needs a dedicated collector reading Triton's own metrics surface — a piqc-style scanner built only for vLLM's exporter sees nothing at all from this class of deployment.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
