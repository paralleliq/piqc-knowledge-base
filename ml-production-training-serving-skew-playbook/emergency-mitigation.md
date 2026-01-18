# Emergency Mitigation: Training–Serving Skew

These actions are intended to be **safe and reversible**.
Goal: restore service quickly, then do deeper root cause analysis.

---

## 1) Roll back to last-known-good
If you have a previous image tag or GitOps revision:

kubectl rollout undo deploy/<name> -n <ns>
kubectl rollout status deploy/<name> -n <ns>

## 2) Pin the configuration (stop “drift”)

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

## 3) Stabilize latency by reducing risk factors

If you’re seeing tail latency spikes:

reduce max output tokens temporarily

reduce max prompt tokens / max context length temporarily

reduce concurrency (max running sequences)

This trades capacity for stability, but avoids meltdown.

Keep changes small; document them so you can revert.

## 4) Route/segment traffic (if available)

If you can route:

send long-context requests to a dedicated deployment

keep normal chat traffic separate

This prevents a small fraction of heavy requests from destabilizing the whole fleet.

## 5) If you suspect hardware skew

If the deployment may have landed on different GPU class:

add node selectors/affinity to force the expected GPU

or temporarily scale down the “bad” nodes / tainted nodes (env-specific)

Quick confirm:

kubectl get pod/<pod> -n <ns> -o jsonpath='{.spec.nodeName}{"\n"}'
kubectl exec -n <ns> <pod> -- nvidia-smi --query-gpu=name,memory.total --format=csv

## 6) Declare the incident resolved only after validation

Minimum validation:

tokens/sec back near baseline

p95/p99 latency stable

GPU util + mem patterns consistent with last good

Capture a “post-fix” evidence bundle for prevention work.

