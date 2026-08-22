## LoRA Serving

**Definition**

Deploying multiple LoRA (Low-Rank Adaptation) adapters against a single shared base model, swapping the active adapter per request instead of loading a fully fine-tuned copy of the model for each variant.

**Why it exists**

Fully fine-tuning and deploying a separate copy of a large model for every customization or task is expensive in both memory and operational overhead. LoRA adapters capture a fine-tuned behavior as a small set of additional low-rank weights layered onto a frozen base model, so many task- or customer-specific variants can share the same base model's memory footprint and just swap the much smaller adapter per request.

**Where in the stack**

Execution layer / Memory management

**Key properties**
- One base model's weights in GPU memory serve many logical model variants simultaneously, each represented by a small adapter
- Adapter swapping happens per request, so a single serving instance can handle requests for many different fine-tuned behaviors concurrently
- GPU memory is shared across all logical models — headroom planning has to account for the base model plus however many adapters are loaded at once, not per logical model independently
- Throughput and latency depend on which adapter is active, since different adapters can correspond to meaningfully different task complexity even on the same base weights
- Tier and capacity requirements apply to the base model, not to each adapter, which is easy to get backwards when reasoning about GPU sizing

**Common pitfalls**
- Sizing GPU capacity per logical model (as if each adapter needed its own full deployment) instead of per shared base model plus adapter overhead
- Not accounting for adapter-swap latency and its effect on tail latency when many different adapters are in high-frequency rotation
- Treating throughput baselines as uniform across adapters when they represent meaningfully different task complexity or output length distributions
- Loading too many adapters concurrently without bounding it, letting adapter memory overhead creep up unnoticed against the shared base model's headroom
- Missing `deployment.loraEnabled` and `deployment.loraAdapterCount` as facts, causing multi-tenant LoRA deployments to be evaluated as if they were single-model deployments

**Related terms**
- KV cache
- GPU HBM
- Quantization
- Tier misplacement
- Model loading
- Multi-tenancy

**In practice**

A single base-model deployment serving 20 LoRA adapters for 20 different customers shows aggregate GPU memory usage dominated by the shared base weights, with only a small marginal cost per additional adapter — tier-misplacement logic that expects one model per deployment will misjudge this as either wildly overprovisioned or, if it miscounts adapters as separate models, wildly underprovisioned.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
