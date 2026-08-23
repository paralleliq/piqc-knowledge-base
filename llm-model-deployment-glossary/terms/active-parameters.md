## Active Parameters vs. Total Parameters

**Definition**

Two different ways to count a model's size: total parameters is every parameter stored in the model regardless of whether a given input uses it; active parameters is only the subset actually touched during a single forward pass. For a dense model the two numbers are identical; for a mixture-of-experts model they diverge sharply.

**Why it exists**

Parameter count has historically been used as shorthand for both a model's capability and its resource cost, and for dense models that shorthand works — every parameter is used on every token, so one number describes both memory footprint and compute cost. Mixture-of-experts architectures break that equivalence on purpose: they route each token through only a handful of experts out of many, so the model can hold far more total knowledge than it spends compute reading on any given token. Once that happens, "how big is this model" stops being a single number.

**Where in the stack**

Execution layer / Model architecture

**Key properties**
- Total parameters determine memory footprint — every expert has to be resident in GPU memory (or unified memory) regardless of activation frequency
- Active parameters determine per-query compute cost and latency — this is what actually gets multiplied through during a forward pass
- Identical for dense models; can differ by 5-10x or more for MoE models (e.g. a 120B-total-parameter MoE model with ≤20B active parameters per token)
- The relevant number depends entirely on which constraint you're reasoning about — memory sizing needs total, compute/latency sizing needs active
- Sizing methodology and product model-tier catalogs built around a single "parameter count" field are implicitly assuming a dense model and will misclassify MoE models unless they track both numbers separately

**Common pitfalls**
- Sizing GPU memory around active parameters alone, when every expert still has to fit in memory regardless of how often it's selected — this is the single most common MoE sizing mistake
- Sizing GPU compute tier around total parameters alone, overestimating the compute a workload actually needs and potentially recommending an oversized (wasteful) tier
- Comparing "parameter count" across a dense model and an MoE model as if it were the same kind of number — a 70B dense model and a 70B-total MoE model have completely different memory and compute profiles
- Model-tier lookup tables or catalogs that store a single parameter-count field per model, with no way to distinguish which number an MoE entry represents
- Assuming quality tracks total parameters alone — active parameters, expert routing quality, and training data all matter, and a large-total, small-active MoE model isn't automatically weaker than a dense model with the same active count

**Related terms**
- Mixture of Experts
- GPU HBM
- Quantization
- LoRA Serving
- Tensor Parallelism
- Tier misplacement

**In practice**

A 120B-total-parameter MoE model with 20B active parameters needs GPU memory sized for the full 120B (every expert must be resident) but compute and latency sized for only 20B — a tier-sizing tool that reads "120B" from a single parameter-count field and applies dense-model assumptions will either recommend an unnecessarily large GPU tier for compute, or an undersized one for memory, depending on which number it happened to read.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
