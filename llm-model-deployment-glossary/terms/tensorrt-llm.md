## TensorRT-LLM

**Definition**

NVIDIA's compiled, hardware-optimized inference engine for LLMs, which builds a model-and-hardware-specific execution plan ahead of time rather than interpreting the model graph at request time.

**Why it exists**

General-purpose inference frameworks trade some raw performance for flexibility — they can run many models with minimal per-model setup. TensorRT-LLM takes the opposite trade: compile a specific model, for a specific GPU architecture, into an optimized execution engine ahead of time, extracting more throughput and lower latency in exchange for a build step and less runtime flexibility.

**Where in the stack**

Execution layer

**Key properties**
- Requires an ahead-of-time compilation/build step per model and per target GPU architecture, unlike frameworks that load and run a model directly
- Commonly deployed as a backend behind Triton Inference Server in enterprise NVIDIA-centric stacks, though it can run standalone
- Supports many of the same optimization techniques as other engines (quantization, paged-attention-style KV cache management, in-flight batching) but implements them in its own compiled execution path
- Performance gains are most pronounced on NVIDIA hardware the engine was specifically compiled for — portability across GPU generations is more limited than interpreted frameworks
- Its own metrics and tuning surface, separate from vLLM's or Triton's platform-level metrics when run as a Triton backend

**Common pitfalls**
- Underestimating the operational cost of the compile step — a model or hardware change requires rebuilding the engine, unlike a framework that just loads new weights
- Assuming performance characteristics transfer across GPU generations without recompiling for the new target architecture
- Conflating TensorRT-LLM (the engine) with Triton (the serving platform that often hosts it) when reasoning about where a metric or bottleneck originates
- Applying vLLM-tuned intuition about configuration knobs directly, when equivalent-sounding settings don't always behave the same way in a compiled engine
- Missing that compiled-engine deployments need their own collector, since neither vLLM-native nor generic Triton-platform metrics fully capture engine-level behavior

**Related terms**
- Triton Inference Server
- Quantization
- Continuous batching
- KV cache
- vLLM
- SGLang

**In practice**

An enterprise account that compiles its production models with TensorRT-LLM and serves them through Triton gets NVIDIA-optimized throughput in exchange for a build pipeline that has to run again any time the model or target GPU generation changes — a very different operational model from swapping weights into a general-purpose framework.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
