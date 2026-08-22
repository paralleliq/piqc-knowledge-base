## Draft Model

**Definition**

A smaller, faster model deployed alongside a larger target model to propose candidate next tokens ahead of time, which the target model then verifies in a single parallel pass — the mechanism speculative decoding is built on.

**Why it exists**

Autoregressive decoding is sequential and latency-bound on the target model's forward-pass cost. If a cheaper model can guess several tokens ahead with reasonable accuracy, the expensive target model only needs one forward pass to verify (and correct) multiple tokens at once, instead of one forward pass per token.

**Where in the stack**

Execution layer / Decoding strategy

**Key properties**
- Runs as a separate, smaller model — a distinct deployment with its own GPU memory and scheduling footprint
- Only proposes candidate tokens; never commits output on its own — the target model's verification is authoritative
- Accuracy against the target model (acceptance rate) is the single biggest driver of end-to-end speedup
- Typically much smaller than the target model (an order of magnitude or more in parameter count) to keep proposal cost cheap
- Shows a distinct, usually much lower, utilization profile than the target model's GPU — this is expected, not a fault

**Common pitfalls**
- A poorly matched draft model produces frequent rejections, wasting the compute spent proposing tokens that get discarded
- The draft model's low GPU utilization looks like misplacement or waste to rules that don't know a draft/target pair exists
- Running two models means two memory budgets to manage — draft model sizing is a real placement decision, not an afterthought
- Draft-target vocabulary or tokenizer mismatches silently break verification correctness
- Self-speculative approaches (Medusa, EAGLE) solve the same problem without a separate draft model — conflating the two when reasoning about a deployment leads to wrong conclusions

**Related terms**
- Speculative decoding
- Self-speculative decoding
- Token verification
- Decode
- Throughput optimization
- Beam search

**In practice**

A draft model's GPU commonly shows utilization in the 10-20% range even in a perfectly healthy deployment — a tier-misplacement rule that doesn't know it's looking at a draft-model pod will flag it as underutilized and recommend a downgrade that breaks speculative decoding.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
