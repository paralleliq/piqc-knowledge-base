# KV Cache Diagnostics (vLLM on Kubernetes)

This guide helps confirm whether **KV cache pressure** is the root cause of
throughput collapse, rising latency, or GPU OOM events in vLLM deployments.

The goal is to distinguish KV cache pressure from:
- generic overload
- compute saturation
- CPU bottlenecks
- networking issues
- autoscaling delays

---

## Quick triage (5 minutes)

### 1) Identify the vLLM pods

```bash
kubectl get pods -n <namespace> -l app=<app-label-value>
```

Example:

```bash
kubectl get pods -n inference -l app=vllm
```

### 2) Check for restarts or OOMKills

```bash
kubectl get pods -n <namespace> -l app=<app-label-value> -o wide
kubectl describe pod/<pod-name> -n <namespace> | \
  egrep -i "oomkilled|reason|exit code|killed|restart|evict"
```

**Interpretation**

- `OOMKilled` or exit code `137` → hard failure (end-stage KV cache pressure)  
- No OOM but instability → likely throughput collapse (early stage)  

**Confirm the KV cache signature**

KV cache pressure has a distinctive signature:

- GPU memory is high  
- GPU compute utilization is low

### 3) Inspect GPU memory and utilization

```bash
kubectl exec -n <namespace> -it pod/<pod-name> -c <container-name> -- nvidia-smi
```

What to look for

- GPU memory usage consistently above ~85–90%
- GPU utilization below ~60% while traffic is present

This pattern indicates:

- memory is saturated by KV cache
- compute cannot be effectively scheduled or batched

### 4) Inspect vLLM logs for allocation pressure

```bash
kubectl logs -n <namespace> pod/<pod-name> -c <container-name> --since=2h | \
  grep -i -E "kv|cache|cuda|oom|alloc|out of memory|memory"
```

If the container restarted, also check previous logs:

```bash
kubectl logs -n <namespace> pod/<pod-name> -c <container-name> --previous --since=2h | \
  grep -i -E "kv|cache|cuda|oom|alloc|out of memory|memory"
```

Common indicators

- CUDA out of memory
- failed to allocate
- KV cache related warnings or errors
- Warnings often appear before a crash.

Identify the trigger.  KV cache pressure is usually triggered by request shape, not raw traffic volume.

### 5) Examine request characteristics (if available)

Check ingress, gateway, or application logs for:

- unusually long prompts  
- large `max_tokens` values  
- bursts of concurrent requests  
- long-lived streaming responses  

KV cache grows roughly with:

concurrency × tokens-in-flight

**Interpretation**

Long prompts or high concurrency are common triggers of KV cache pressure.

Proceed to the next step to check Kubernetes context.


### 6) Review recent Kubernetes events

```bash
kubectl get events -n <namespace> --sort-by=.lastTimestamp | tail -n 50
```

**Interpretation**

Look for:

- node memory pressure
- evictions
- scheduling delays
- restarts

These do not cause KV cache pressure directly, but they can:

- amplify memory pressure
- trigger fragmentation
- obscure the root cause
- accelerate failure

Proceed to validate batching collapse if metrics are available.

### 7) Port-forward the metrics endpoint (if metrics are available)

```bash
kubectl get pod/<pod-name> -n <namespace> -o \
  jsonpath='{range .spec.containers[*]}{.name}{"\t"}{.ports}{"\n"}{end}' ; echo
```

Fallback if ports are not declared in the spec:

```bash
kubectl describe pod/<pod-name> -n <namespace> | grep -i -A2 "Ports"
```

If you already expose /metrics on the main HTTP port (common), it’s often 8000.

### 8) Inspect metrics

```bash
kubectl port-forward -n <namespace> pod/<pod-name> <local-port>:<container-port>
curl -s localhost:<local-port>/metrics | head
```

Example: Using metric endpoint on container port 8000

```bash
kubectl port-forward -n <namespace> pod/<pod-name> 8000:8000
curl -s localhost:8000/metrics | head
```

Signals to look for

- effective batch size (p95) dropping to ~1–2
- p95 / p99 latency increasing
- token-per-output-time increasing
- Batch collapse combined with high GPU memory strongly confirms KV cache pressure.

**Interpretation** 

Use the following patterns to classify the failure mode.

Likely KV cache pressure.  Most of the following are true:

- GPU memory > 85–90%
- GPU utilization < ~60%
- effective batch size collapses
- p95 / p99 latency rises
- throughput plateaus or declines

This indicates the system is memory-saturated due to KV cache growth.

Likely compute-bound

- GPU memory moderate
- GPU utilization consistently high (>80–90%)
- batching remains effective
- throughput continues to scale with traffic

This indicates the workload is compute-limited, not memory-limited.

Likely CPU / networking / tokenization bound

- GPU memory not high
- GPU utilization low
- CPU saturation present
- networking delays or queueing observed

This indicates the bottleneck is outside the GPU execution path.

