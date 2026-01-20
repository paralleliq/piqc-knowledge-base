# Prevention: Training–Serving Skew

Skew is best prevented by treating deployment settings as a **contract**.

---

## 1) Pin everything that matters
- container images (immutable tags + digests)
- model artifact revision (HF commit, S3 version)
- tokenizer revision
- runtime version
- dtype and quantization
- max model len / generation limits
- tensor parallel / pipeline parallel settings

---

## 2) Make intent explicit ([ModelSpec-style](https://github.com/paralleliq/modelspec))
Declare the intended:
- model identity + revision
- runtime engine + version
- dtype + quantization
- max context length
- concurrency caps
- autoscaling signal type
- hardware constraints (GPU class, VRAM)

Then compare it to “what is running.”

---

## 3) Add a pre-deploy “skew check”
Before rollout, validate:
- args/env match expected
- model revision pinned
- GPU class matches expected
- a minimal performance sanity test passes (tokens/sec + latency)

Even 2–3 checks catch most incidents.

---

## 4) Record a baseline
For each production endpoint, store a baseline snapshot:
- tokens/sec at a known load
- p95/p99 latency
- GPU util/mem utilization
- effective batch p95 (if available)

Baselines make regressions obvious and speed root cause.

---

## 5) Continuous drift detection (advanced, optional)

For mature deployments, consider introducing lightweight drift detection to catch
silent configuration changes before they cause performance regressions or failures.

Pattern:

- periodically sample “live facts” from running workloads  
- compare against declared intent (images, model revision, dtype, limits)  
- alert only when diffs exceed safe thresholds  

This is intentionally **not** full monitoring.  
The goal is early detection of configuration drift without adding operational noise.

### Note:  
This pattern can be implemented with custom scripts, admission checks, or future
advisory tooling. It is most valuable in GPU-constrained environments where small
drifts can lead to OOMs, latency spikes, or irreproducible behavior.

