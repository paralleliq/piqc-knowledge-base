# Diagnostics: Training–Serving Skew (Configuration Mismatch)

This page is structured as:
1) Confirm a skew incident is plausible
2) Identify what changed (diff)
3) Pinpoint the mismatch category
4) Capture a minimal evidence bundle

> Tip: Skew debugging is fastest when you compare “last good” vs “current” side-by-side.

---

## 1) Confirm it looks like skew (not a pure capacity issue)

### Symptoms that often indicate skew
- Regression appeared after a rollout or infra change (even “no code change”)
- Throughput dropped while GPU/CPU utilization patterns changed unexpectedly
- Latency tails (p95/p99) worsened without traffic increase
- Quality regressions reported after deployment changes

### Quick checks (Kubernetes)
Identify pods:

kubectl get pods -n \<ns\> -l app=\<app\>

Check image + restarts:

kubectl get pods -n <ns> -l app=<app> \\
  -o custom-columns=NAME:.metadata.name,IMAGES:.spec.containers[*].image,RESTARTS:.status.containerStatuses[*].restartCount


Describe the workload:

kubectl describe deploy/\<name\> -n \<ns\>

## 2) Diff “last good” vs “current” (highest ROI)

### A) Diff the Deployment spec

kubectl get deploy/\<name\> -n \<ns\> -o yaml \> current.yaml

Compare against a saved last-good YAML (or GitOps repo)

diff -u last-good.yaml current.yaml | less

### B) Diff the container args and env

kubectl get pod/\<pod\> -n \<ns\> -o jsonpath='{.spec.containers[0].args}' ; echo

kubectl get pod/\<pod\> -n \<ns\> -o jsonpath='{.spec.containers[0].env}'  ; echo

### C) Diff config maps / secrets referenced by the pod

kubectl describe pod/\<pod\> -n \<ns\> | sed -n '/Mounts:/,/QoS Class:/p'

kubectl get cm -n \<ns\>

kubectl get secret -n \<ns\>

## 3) Pinpoint mismatch category

### 3.1 Model artifacts mismatch (weights/tokenizer/config)

#### What to confirm

model name + revision/commit

tokenizer version

config (e.g., rope scaling, max position embeddings)

where artifacts are fetched from (HF, S3/GCS)

#### Commands

If your container prints model info at startup:

kubectl logs -n \<ns\> \<pod\> --since=2h | grep -iE "model|tokenizer|revision|commit|sha|hf"

If you mount artifacts:

kubectl exec -n \<ns\> \<pod\> -- ls -lah /models || true
kubectl exec -n \<ns\> \<pod\> -- find /models -maxdepth 2 -type f | head

### 3.2 Runtime config mismatch (dtype/quant/batching/context/concurrency)

#### What to confirm

dtype (fp32 vs bf16/fp16)

quantization (AWQ/GPTQ)

max model len / max prompt tokens

concurrency (max running sequences)

tensor parallel (tp) and pipeline parallel (pp)

#### Commands

Inspect args/env:

kubectl get pod/\<pod\> -n \<ns\> -o jsonpath='{.spec.containers[0].args}' ; echo
kubectl get pod/\<pod\> -n \<ns\> -o jsonpath='{.spec.containers[0].env}'  ; echo

Check vLLM metrics endpoint (if exposed):

kubectl port-forward -n \<ns\> pod/\<pod\> 8000:8000
curl -s localhost:8000/metrics | grep -iE "token|request|latency|batch|running|queue" | head -n 80

### 3.3 Hardware mismatch (GPU class/VRAM/interconnect/drivers)

#### What to confirm

GPU model and VRAM

driver/CUDA version

MIG mode (if any)

PCIe vs NVLink/NVSwitch in multi-GPU

#### Commands

If nvidia-smi is present in the container:

kubectl exec -n \<ns\> \<pod\> -- nvidia-smi
kubectl exec -n \<ns\> \<pod\> -- nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv


Also check node scheduling:

kubectl get pod/\<pod\> -n \<ns\> -o jsonpath='{.spec.nodeName}{"\n"}'
kubectl describe node/\<node\> | grep -iE "gpu|nvidia|allocatable|capacity" -n

### 3.4 Serving layer mismatch (timeouts/streaming/retries/request limits)

#### What to confirm

request timeouts vs max generation

streaming enabled/disabled (changes concurrency and tail latency)

retries amplifying load

request size limits / max body size

#### Commands

Check ingress/service annotations:

kubectl describe ingress/\<name\> -n \<ns\>
kubectl describe svc/\<name\> -n \<ns\>


If using Envoy/Istio, check config (varies by env). At minimum, capture:

timeout

retry policy

max request size

### 3.5 Orchestration mismatch (autoscaling signals/resources/node affinity)

#### What to confirm

HPA metric type (CPU vs custom)

resource requests/limits changed

node affinity/taints causing different GPU class

warm pool / min replicas changed

#### Commands

kubectl get hpa -n \<ns\>
kubectl describe hpa/\<name\> -n \<ns\>

kubectl get deploy/\<name\> -n \<ns\> -o jsonpath='{.spec.template.spec.containers[0].resources}{"\n"}'
kubectl get deploy/\<name\> -n \<ns\> -o jsonpath='{.spec.template.spec.affinity}{"\n"}'

## 4) Minimal evidence bundle (attach to an issue)

When you file an issue (internal or OSS), capture:

workload identity: namespace, deployment name, pod list

image tag + digest

container args + env (redact secrets)

GPU type + driver version

key runtime metrics snapshots (tokens/sec, latency p99, GPU util/mem)

diff vs last-good (or the date/time of last-good)

This makes skew debuggable.
