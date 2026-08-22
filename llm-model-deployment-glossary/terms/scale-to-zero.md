## Scale-to-Zero

**Definition**

An autoscaling policy that allows a deployment's replica count to drop to zero during periods of no traffic, eliminating idle GPU cost entirely rather than maintaining a minimum standby footprint.

**Why it exists**

Keeping even one replica warm for a rarely-used model means paying for a GPU the entire time it sits idle. For workloads with genuinely intermittent traffic, scale-to-zero removes that cost entirely — the trade-off is that the next request has to wait for a replica to come back up from nothing, which for large models means a full cold start.

**Where in the stack**

Control Plane / Orchestration

**Key properties**
- Only economically sensible for workloads with real idle gaps — traffic that's merely bursty but constant doesn't benefit and pays cold-start cost repeatedly for no savings
- The first request after scaling to zero pays the full cold-start penalty: model loading, weight transfer to GPU memory, and warm-up
- Directly opposed to warm pool strategies, which accept idle cost specifically to avoid this penalty
- Requires the control plane to detect zero traffic reliably and to provision replacement capacity fast enough that the resulting cold start is tolerable
- A core lever in serverless LLM architectures, where cost efficiency for spiky or rare workloads is the primary goal

**Common pitfalls**
- Applying scale-to-zero to latency-sensitive or frequently-hit endpoints, where the recurring cold-start penalty outweighs the idle-cost savings
- Not accounting for provisioning latency when setting the scale-down timeout — being too aggressive about scaling to zero increases the frequency of the expensive cold path
- Assuming scale-to-zero and warm pools are mutually exclusive, when many architectures use a hybrid: keep a small warm buffer, scale below that to zero
- Cost models that only account for GPU-hours saved without accounting for the latency cost users experience on every cold start
- Traffic patterns that look sporadic in aggregate but are actually frequent at the individual-tenant level, making scale-to-zero a poor fit despite the aggregate metrics suggesting otherwise

**Related terms**
- Cold start
- Warm pool
- Serverless architecture
- Provisioning latency
- Autoscaling
- Scale-up latency

**In practice**

A rarely-used fine-tuned model serving occasional batch jobs is a good scale-to-zero candidate — the idle-cost savings between requests far outweigh a cold start nobody's waiting on synchronously; a customer-facing chat endpoint is a poor one, since users feel every cold start directly.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
