
---

# `emergency-mitigation.md`

```markdown
# Emergency Mitigation: Training–Serving Skew

These actions are intended to be **safe and reversible**.
Goal: restore service quickly, then do deeper root cause analysis.

---

## 1) Roll back to last-known-good
If you have a previous image tag or GitOps revision:
```bash
kubectl rollout undo deploy/<name> -n <ns>
kubectl rollout status deploy/<name> -n <ns>

2) Pin the configuration (stop “drift”)

Common drift sources:

using :latest

unpinned model revision

default dtype changing between versions

Actions:

pin image tag (immutable)

pin model revision/commit

explicitly set dtype and max model len

Validate by re-checking args/env:

kubectl get pod/<pod> -n <ns> -o jsonpath='{.spec.containers[0].args}' ; echo
kubectl get pod/<pod> -n <ns> -o jsonpath='{.spec.containers[0].env}'  ; echo

3) Stabilize latency by reducing risk factors

If you’re seeing tail latency spikes:

reduce max output tokens temporarily

reduce max prompt tokens / max context length temporarily

reduce concurrency (max running sequences)

This trades capacity for stability, but avoids meltdown.

Keep changes small; document them so you can revert.

4) Route/segment traffic (if available)

If you can route:

send long-context requests to a dedicated deployment

keep normal chat traffic separate

This prevents a small fraction of heavy requests from destabilizing the whole fleet.

5) If you suspect hardware skew

If the deployment may have landed on different GPU class:

add node selectors/affinity to force the expected GPU

or temporarily scale down the “bad” nodes / tainted nodes (env-specific)

Quick confirm:

kubectl get pod/<pod> -n <ns> -o jsonpath='{.spec.nodeName}{"\n"}'
kubectl exec -n <ns> <pod> -- nvidia-smi --query-gpu=name,memory.total --format=csv

6) Declare the incident resolved only after validation

Minimum validation:

tokens/sec back near baseline

p95/p99 latency stable

GPU util + mem patterns consistent with last good

Capture a “post-fix” evidence bundle for prevention work.


---

# `prevention.md`

```markdown
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

## 2) Make intent explicit (ModelSpec-style)
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

## 5) Continuous drift detection (optional)
If you have scanners/advisors:
- periodically sample “live facts”
- compare against desired intent
- alert only when diffs exceed safe thresholds

This avoids turning PIQC into a full monitoring system while still catching drift early.
