## DCGM (Data Center GPU Manager)

**Definition**

NVIDIA's hardware-level GPU management and telemetry system, exposing metrics — SM utilization, memory bandwidth, NVLink bandwidth, temperature, power draw, ECC error counts — directly from the device rather than through an inference framework's own instrumentation.

**Why it exists**

Inference frameworks like vLLM expose metrics scoped to their own execution (requests, KV cache, tokens per second), but they don't necessarily surface true hardware-level state: is the GPU thermal throttling, is memory bandwidth saturated, are ECC errors climbing toward a hardware failure. DCGM exists as the authoritative source for that hardware layer, independent of whatever inference engine happens to be running on top.

**Where in the stack**

GPU & Memory / Observability

**Key properties**
- Framework-agnostic — the same DCGM signals apply whether the GPU is running vLLM, SGLang, Triton, or anything else
- Exposes root-cause hardware signals (thermal state, power draw, ECC errors, NVLink health) that framework-level metrics can't see
- Distinguishes causes of low GPU utilization that look identical from the framework's perspective — thermal throttling, power capping, and genuine idle time all show up as "low utilization" without DCGM's additional context
- The standard basis for detecting hardware degradation before it causes an outright failure — rising ECC errors, for instance, precede uncorrectable errors and job crashes
- Complementary to, not a replacement for, framework-level metrics — DCGM tells you about the device, not about requests or tokens

**Common pitfalls**
- Relying solely on inference-framework metrics and missing hardware-level root causes entirely — thermal throttling and power capping look like ordinary "low utilization" without DCGM
- Treating a DCGM-reported ECC error as a one-off rather than tracking its trend, missing the escalation pattern that precedes hardware failure
- Not correlating DCGM hardware signals with the specific workload running on that GPU, losing the ability to say which model or customer is actually affected
- Assuming DCGM data alone is sufficient without framework-level context — knowing the GPU is thermal throttling still requires framework metrics to know which requests that's degrading
- Underinvesting in DCGM-based collection because current framework-native metrics look "good enough," missing failure modes that only DCGM surfaces

**Related terms**
- GPU HBM
- Thermal throttling
- ECC error escalation
- NVLink
- MIG
- OpenTelemetry

**In practice**

A GPU reading low utilization from vLLM's own metrics can mean genuine idle capacity, or it can mean the GPU is thermal throttling and physically incapable of running faster — only a DCGM-level temperature and clock-speed reading distinguishes "nothing to do" from "cannot go faster."


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
