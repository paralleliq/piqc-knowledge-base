## Mixture of Experts (MoE)

**Definition**

A model architecture where each layer contains multiple parallel "expert" sub-networks, but a routing mechanism activates only a small subset of them per token, so the model's total parameter count is far larger than the compute cost paid per forward pass.

**Why it exists**

Model quality generally scales with parameter count, but compute cost scales with it too in a dense model — every parameter is used on every token. MoE breaks that coupling: a router selects a handful of experts per token (commonly 1-2 out of dozens), so the model can hold far more total parameters (and therefore more capacity/knowledge) while only paying the compute cost of the smaller active subset on any given forward pass.

**Where in the stack**

Execution layer / Model architecture

**Key properties**
- Total parameter count and active parameter count are different numbers — "a 400B MoE model" often means far fewer parameters actually compute per token
- GPU memory still has to hold all experts, even though only a few are active per token — MoE saves compute, not memory
- Routing decisions vary per token, so which experts are active (and therefore which GPUs are busy, in an expert-parallel deployment) shifts dynamically
- Expert-parallel deployment spreads different experts across different GPUs, adding a communication step (routing tokens to the GPU holding the selected expert) not present in dense models
- Load imbalance across experts is a first-class concern — some experts get selected far more often than others, unevenly loading whichever GPUs host them

**Common pitfalls**
- Sizing GPU memory around active parameter count instead of total parameter count — every expert has to be resident in memory regardless of how often it's selected
- Assuming MoE models are cheaper to serve in the same way they're cheaper to train — memory footprint doesn't shrink even though compute per token does
- Expert-parallel deployments introduce routing communication overhead that dense-model tensor/pipeline parallelism doesn't have, and that overhead is easy to miss in capacity planning
- Uneven expert selection frequency creates hot GPUs in an expert-parallel deployment, a load-imbalance failure mode with no equivalent in dense models
- Comparing MoE and dense model throughput or utilization baselines directly, when active-vs-total parameter count differences make naive comparisons misleading

**Related terms**
- Quantization
- Tensor parallelism
- Data parallelism
- GPU HBM
- Collective communication
- Model parallelism

**In practice**

A large MoE model can require GPU memory sized for its full parameter count while only ever exercising a fraction of that compute per token — a deployment sized around "active" FLOPs alone will hit OOM the moment memory, not compute, turns out to be the actual constraint.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
