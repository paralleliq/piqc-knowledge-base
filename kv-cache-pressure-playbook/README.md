# KV Cache Pressure & GPU OOM in vLLM (Kubernetes)

This playbook documents one of the most common production failure modes in
LLM inference using vLLM on Kubernetes:

> **KV cache pressure causing throughput collapse — often followed by GPU OOM.**

This issue typically appears *before* crashes, when the system is already
degraded but still serving traffic.

> **Applies to AMD and NVIDIA GPUs**
>
> KV cache pressure is a function of model architecture, sequence length, and concurrency.
> It affects LLM runtimes on both AMD and NVIDIA GPUs equally.
> The examples in this guide use vLLM metrics on NVIDIA hardware; equivalent signals exist on AMD via ROCm tooling.

---

## What this playbook covers

- How to recognize KV cache pressure early
- How to stabilize a degraded system
- How to confirm KV cache as the root cause
- How to prevent recurrence through explicit limits

This guide is written for ML engineers, platform teams, and SREs
operating LLM inference in production.

---

## Mental model

vLLM stores **KV cache** in GPU memory for every active token of every active
request. As concurrency, prompt length, or output length increases, GPU
memory usage grows linearly.

When memory is near full:
- batching collapses
- decode slows down
- latency spikes
- GPU compute becomes underutilized

Eventually, allocations fail and the pod crashes with GPU OOM.

---

## Typical symptoms

You are likely experiencing KV cache pressure if several of these occur together:

- GPU memory > 85–90%
- GPU compute utilization < 60%
- Effective batch size collapses (p95 ≈ 1–2)
- p95 / p99 latency increases sharply
- Pods eventually restart or get OOMKilled

👉 See detailed symptoms:  [`symptoms.md`](./symptoms.md)

---

## Emergency mitigation (stop the bleeding)

If the system is already unstable, apply these immediately:

- Cap input and output tokens
- Reduce concurrent sequences
- Reduce batching aggressiveness
- Reserve GPU memory headroom

👉 Step-by-step commands:  [`emergency-mitigation.md`](./emergency-mitigation.md)

---

## Confirming the root cause

To verify this is KV cache pressure (not networking or autoscaling):

- Inspect GPU memory usage
- Check vLLM logs for allocation failures
- Correlate request size and concurrency

👉 Diagnostics:  [`diagnostics.md`](./diagnostics.md)

---

## Preventing this next time

KV cache explosions are not random — they result from missing limits.

Prevention requires:
- explicit token limits
- explicit concurrency limits
- explicit GPU memory headroom
- visibility into batch effectiveness
- possibly chunked prefill

👉 Prevention checklist:  [`prevention.md`](./prevention.md)

---

## Why this keeps happening in production

Most teams monitor GPU utilization, but not:
- memory per request
- prompt length distribution
- KV cache growth

As a result, systems look healthy — until they suddenly aren’t.

---

## If this happens repeatedly

You likely don’t have a tuning problem.

You have a **model execution control problem**, where nothing enforces what
the model is allowed to do under load.

