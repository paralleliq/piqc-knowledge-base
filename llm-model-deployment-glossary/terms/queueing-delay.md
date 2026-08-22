## Queueing Delay

**Definition**

The time a request spends waiting to be admitted into the running batch before its actual processing (prefill and decode) begins — latency added by contention for capacity, not by the model doing work.

**Why it exists**

When demand exceeds what a deployment can admit immediately, requests have to wait somewhere. Queueing delay isolates that waiting time from service time so operators can tell whether slow responses are caused by the model being slow or by there simply not being room to start the request yet — two very different problems with different fixes.

**Where in the stack**

Serving layer / Scheduling

**Key properties**
- Strictly the time before processing starts — separate from TTFT, which is measured from admission, not arrival
- Driven by admission control policy, current active sequence count, and available KV cache headroom
- Rises sharply and nonlinearly as a deployment approaches its concurrency ceiling, rather than degrading gradually
- The primary lever autoscaling pulls to control — adding replicas or capacity reduces queueing delay without changing per-request service time
- Susceptible to head-of-line blocking if the admission queue itself isn't fair or priority-aware

**Common pitfalls**
- Reporting only end-to-end latency, which conflates queueing delay with actual model service time and hides which one is the real bottleneck
- Assuming rising end-to-end latency means the model or GPU has gotten slower, when the deployment is simply saturated and requests are waiting longer to start
- Autoscaling reaction time (provisioning latency) that's slower than the traffic burst causing the queueing delay, so new capacity arrives after the delay has already spiked
- Not separating queueing delay by request priority or class, hiding that low-priority requests are absorbing disproportionate wait time
- Treating queueing delay as evidence of undercapacity everywhere, when a small, well-configured queue is sometimes intentional cost/latency trade-off

**Related terms**
- Admission control
- Head-of-line blocking
- Tail latency
- TTFT
- Autoscaling
- Active sequences

**In practice**

A deployment can show a healthy average TTFT while overall response latency climbs under load — the gap between the two is queueing delay, and it's the signal that says "add capacity" rather than "optimize the model."


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
