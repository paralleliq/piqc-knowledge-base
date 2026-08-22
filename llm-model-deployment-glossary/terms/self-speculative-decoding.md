## Self-Speculative Decoding

**Definition**

A decoding technique where extra prediction heads or a lightweight mechanism attached to the same model weights propose several future tokens, which the base model then verifies in a single parallel forward pass — getting speculative decoding's throughput gain without running a separate draft model.

**Why it exists**

Classic speculative decoding needs a second, smaller model to propose candidate tokens, which adds a separate model to deploy, size, and keep matched to the target model. Self-speculative approaches — Medusa, EAGLE, and lookahead decoding are the common implementations — attach the proposal mechanism directly to the target model instead, avoiding a second model's memory footprint and deployment complexity while still batching multiple token guesses into one verification pass.

**Where in the stack**

Execution layer / Decoding strategy

**Key properties**
- No separate draft-model pod — proposal and verification happen inside the same model's forward pass
- Extra prediction heads (Medusa) or a draft tree built from the model's own hidden states (EAGLE, lookahead decoding) generate candidate continuations
- Token acceptance rate still governs effective throughput, the same way it does in draft-model speculative decoding
- Increases tokens-per-second without a second model's GPU memory and scheduling overhead
- Requires the base model to be fine-tuned or augmented with the extra heads/mechanism ahead of time

**Common pitfalls**
- No second pod to detect — a fact schema that only looks for a draft-model deployment misses this entirely
- Low token acceptance rate makes the deployment look like a healthy single model serving unusually slowly, not like a speculative-decoding deployment underperforming
- Extra prediction heads add a small but nonzero memory and compute overhead per forward pass even when acceptance is high
- Requires the augmented model artifact to be kept in sync with the base model across upgrades
- Harder to reason about than draft-model speculative decoding since there's no separate component to isolate when debugging

**Related terms**
- Speculative decoding
- Beam search
- Decode
- Autoregressive decoding
- Throughput optimization
- Draft model

**In practice**

A deployment using Medusa or EAGLE shows the same token-acceptance-driven throughput variability as classic speculative decoding, but without a second model pod for monitoring to key off — a fact schema built only around `draft_model` presence will silently miss it.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
