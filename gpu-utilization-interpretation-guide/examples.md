# Examples: GPU Utilization Patterns in LLM Inference

This page shows common real-world GPU utilization patterns and how to interpret them.

---

## Example 1: Low GPU Utilization + High Memory Usage

**Observed**
- GPU memory: 90%+
- GPU utilization: 40–60%
- effective batch size (p95): 1–2
- latency p99 increasing

**Interpretation**
- KV cache pressure causing batching collapse
- GPU is memory-bound, not compute-bound

**Action**
- reduce max context length
- segment long-context traffic
- increase memory headroom (quantization or higher-VRAM GPU)

---

## Example 2: High GPU Utilization + Low Throughput

**Observed**
- GPU utilization: 85–95%
- tokens/sec lower than expected
- latency higher than benchmark

**Interpretation**
- over-sharded model (tensor parallelism too high)
- communication overhead dominating compute

**Action**
- reduce tensor parallelism
- scale replicas instead of sharding
- prefer faster interconnects if sharding is required

---

## Example 3: Low GPU Utilization + Low Traffic

**Observed**
- GPU utilization: <30%
- memory usage stable and low
- latency low and stable
- queue depth near zero

**Interpretation**
- request starvation
- system is healthy but underloaded

**Action**
- no action required
- do not scale down solely on utilization

---

## Example 4: Spiky GPU Utilization

**Observed**
- GPU utilization oscillates sharply
- latency spikes during troughs
- throughput unstable

**Interpretation**
- bursty traffic interacting with batching window
- insufficient queue depth for stable batching

**Action**
- increase batching window slightly
- tune max concurrency
- consider request shaping or smoothing



---

### 🔹 Add to `examples.md`

```markdown
## Example: Low GPU Utilization with MIG Enabled

**Observed**
- GPU utilization (slice): 60–70%
- slice memory usage: >90%
- effective batch size (p95): 1–2
- latency increasing

**Interpretation**
- MIG slice is memory-constrained
- KV cache pressure occurring earlier than expected
- utilization appears “reasonable” but batching is collapsing

**Action**
- use larger MIG profiles for LLM inference
- reduce max context length
- avoid MIG for long-context or high-concurrency LLM workloads

