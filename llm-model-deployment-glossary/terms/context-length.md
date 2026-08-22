## Context Length (Max Model Length)

**Definition**

The maximum number of tokens a model can hold in its attention window at once — the combined input (prompt, system message, conversation history) plus generated output — fixed at training time and not extendable at serving time.

**Why it exists**

A transformer's attention mechanism computes relationships between every pair of tokens in its window, and the model is trained with a specific maximum window size in mind. Beyond that limit the model has no learned representation for how to attend across the gap — it isn't a soft degradation, it's a hard ceiling on how much the model can consider at once. Context length is the number that defines where that ceiling sits.

**Where in the stack**

Execution layer

**Key properties**
- Fixed per model checkpoint — a property of how the model was trained, not a runtime configuration knob
- Directly determines maximum KV cache size per sequence, since every token in context needs a cache entry for the life of the request
- Applies to combined input plus output — a long prompt leaves less room for the model to generate before hitting the ceiling
- Serving frameworks expose a separate, often smaller, configured `max_model_len` to cap real-world usage below the model's trained maximum, trading context headroom for KV cache capacity across more concurrent requests
- Requests that exceed it are truncated, rejected, or (with sufficient headroom) simply refused admission, depending on how the serving layer is configured

**Common pitfalls**
- Confusing the model's trained context length with the deployment's configured `max_model_len` — the second is often deliberately set lower to leave more KV cache headroom for concurrency
- Assuming a larger advertised context length is free — every additional token of context multiplies KV cache cost per sequence, directly reducing how many concurrent sequences a fixed amount of GPU memory can support
- Silently truncating overflow content instead of surfacing an error, producing plausible-looking but subtly wrong output when a request exceeds the window
- Not accounting for output tokens against the same budget as input — a request with a prompt near the limit can fail or get cut off mid-generation once output tokens are added
- Sizing GPU capacity around expected prompt length alone without checking whether occasional long-context requests will need proportionally much larger KV cache per sequence

**Related terms**
- KV cache
- Token maxing
- Prefill
- Paged attention
- GPU HBM
- Chunked prefill

**In practice**

A model with a 128K-token context length can hold roughly 90,000-100,000 words of combined prompt and output in a single request; a deployment configuring `max_model_len` down to 32K to fit more concurrent sequences in the same GPU memory will reject or truncate any request that needs the model's full trained window, regardless of what the model card advertises.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
