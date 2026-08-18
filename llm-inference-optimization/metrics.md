# LLM Inference Metrics

## Prefill Metrics

TTFT
Time to first token.

Prompt tokens/sec
Speed of prompt processing.

Prefill latency
Total time spent building KV cache.

---

## Decode Metrics

Inter-token latency
Time between generated tokens.

Tokens/sec
Throughput during generation.

Tokens/sec/GPU
Infrastructure efficiency.

---

## System Metrics

GPU utilization

Memory bandwidth utilization

Active sequences per GPU

KV cache memory usage

---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
