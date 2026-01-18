
---

## `common-misinterpretations.md`

```markdown
# Common Misinterpretations of GPU Utilization

This page documents frequent but incorrect conclusions teams draw from GPU utilization metrics in LLM inference systems.

---

## Misinterpretation #1: “Low GPU utilization means wasted capacity”

**Why this is wrong**
- The GPU may be memory-bound rather than compute-bound
- KV cache pressure can prevent batching even with available compute
- Small or serialized batches reduce utilization without reducing latency

**What to check instead**
- GPU memory utilization
- effective batch size (p95)
- tokens/sec trend

---

## Misinterpretation #2: “High utilization means good performance”

**Why this is wrong**
- A GPU can be fully utilized processing inefficiently
- Over-sharding (high tensor parallelism) can drive utilization without improving throughput
- Communication overhead may dominate compute

**What to check instead**
- tokens/sec per GPU
- latency p95 / p99
- interconnect type (PCIe vs NVLink)

---

## Misinterpretation #3: “We should scale down if utilization is low”

**Why this is dangerous**
- Low utilization during KV cache pressure indicates *inefficiency*, not spare capacity
- Scaling down may worsen latency and increase queueing
- The system may already be near a failure point

**What to check instead**
- batching effectiveness
- memory headroom
- per-replica throughput

---

## Misinterpretation #4: “CPU autoscaling will fix low GPU utilization”

**Why this fails**
- CPU metrics do not reflect GPU execution constraints
- LLM capacity is governed by tokens/sec and memory
- Autoscaling on CPU often adds replicas without improving per-replica efficiency

**What to check instead**
- tokens/sec per replica
- GPU utilization vs latency correlation
- autoscaling signal choice

## Misinterpretation #5: “GPU utilization looks fine, so capacity is fine (with MIG)”

**Why this is wrong**
When MIG is enabled, GPU utilization is scoped to the MIG slice, not the full physical GPU.
A MIG slice may show high utilization or memory pressure while the host GPU appears mostly idle.

This commonly leads to:
- underestimating memory pressure
- misdiagnosing batching collapse
- incorrect scaling decisions

**What to check instead**
- whether MIG is enabled
- the MIG profile (e.g., 1g.10gb, 2g.20gb)
- memory headroom *within the slice*
- tokens/sec relative to slice size

