## Quantization

**Definition**

Reducing the numerical precision used to represent model weights (and sometimes KV cache or activations) — for example from FP16 to INT8 or INT4 — to cut memory footprint and often increase throughput, at some cost to output quality.

**Why it exists**

Model weights and KV cache dominate GPU memory usage, and full precision (FP16/BF16) isn't always necessary to preserve acceptable output quality. Quantization trades numerical precision for a smaller memory footprint per parameter or per cached token, freeing up capacity for larger models, bigger batches, or longer context on the same hardware.

**Where in the stack**

Execution layer / Memory management

**Key properties**
- Applies independently to weights and to KV cache — a deployment can quantize one, both, or neither
- Lower precision directly reduces HBM consumption per parameter or per cached token, proportionally increasing effective capacity
- Can also increase throughput, since moving less data per operation reduces memory-bandwidth pressure, particularly beneficial for the memory-bound decode phase
- Quality impact varies by model, task, and quantization method — not a uniform, guaranteed-safe trade-off
- KV cache quantization (e.g., int8 KV) is a distinct lever from weight quantization, useful specifically for relieving token-maxing-style cache pressure without touching model weights

**Common pitfalls**
- Assuming quantization is free — quality degradation is real and task-dependent, and needs to be validated, not assumed away
- Quantizing weights without checking whether KV cache, not weights, is the actual memory bottleneck for the workload in question
- Running a workload at full precision "because that's the default" when the model, hardware, and quality bar would tolerate INT8 or INT4 at meaningfully lower cost
- Not re-validating quality after a quantization change, especially for tasks sensitive to numerical precision (reasoning, code generation, structured output)
- Confusing KV cache quantization with weight quantization when reading vendor documentation or configuration flags — they're separate settings addressing separate constraints

**Related terms**
- KV cache
- GPU HBM
- Token maxing
- Model loading
- Throughput optimization
- MIG

**In practice**

A workload running FP16 that's hitting KV cache saturation (token maxing) can often recover meaningful headroom by enabling INT8 KV cache quantization alone, without touching weight precision or model quality at all — a cheaper first lever than moving to a larger GPU tier.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
