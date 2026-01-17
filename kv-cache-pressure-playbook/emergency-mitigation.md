# Emergency Mitigation (vLLM KV Cache Pressure)

Use this when vLLM is degraded (latency rising, throughput collapsing) or you’re near/at GPU OOM.
Goal: **stop the bleeding** by reducing KV cache growth and restoring headroom.

---

## Before you start (pick the target)

### Identify the vLLM pods
```bash
kubectl get pods -n <namespace> -l app=<vllm-label>
Optional: watch restarts

bash
Copy code
kubectl get pods -n <namespace> -l app=<vllm-label> -w
Step 1 — Stabilize traffic (fastest win)
1A) Enforce token limits at the edge (recommended)
If you have an API gateway / router / app layer, temporarily enforce:

max input tokens

max output tokens

reject oversized requests (HTTP 400/413)

This immediately reduces KV cache growth.

Step 2 — Reduce in-flight concurrency
2A) Lower max_num_seqs (vLLM concurrency)
In your vLLM args/env, reduce:

text
Copy code
--max-num-seqs <lower-value>
Rule of thumb: cut it by 25–50% during an incident.

Why it helps:

KV cache ≈ concurrency × tokens-in-flight

lowering concurrency reduces KV memory pressure immediately

Step 3 — Reduce batching aggressiveness
3A) Lower max-num-batched-tokens
Reduce:

text
Copy code
--max-num-batched-tokens <lower-value>
Why it helps:

aggressive batching increases tokens in flight

reducing it reduces KV cache footprint and fragmentation risk

Step 4 — Reserve GPU memory headroom
4A) Lower GPU memory utilization target
Set:

text
Copy code
--gpu-memory-utilization 0.7
If still unstable, go lower:

text
Copy code
--gpu-memory-utilization 0.6
Why it helps:

leaves room for allocator overhead and fragmentation

prevents hard allocation failures

Step 5 — Apply changes safely (Kubernetes)
5A) Patch your deployment (typical workflow)
Edit the deployment (recommended):

bash
Copy code
kubectl edit deploy -n <namespace> <deployment-name>
Or update your Helm values / manifest and redeploy.

Then watch rollout:

bash
Copy code
kubectl rollout status deploy -n <namespace> <deployment-name>
Step 6 — If you are already crashing (controlled restart)
If pods are repeatedly OOMKilled or memory is badly fragmented, do a controlled restart
after you have reduced limits:

bash
Copy code
kubectl rollout restart deploy -n <namespace> <deployment-name>
kubectl rollout status deploy -n <namespace> <deployment-name>
Step 7 — Verify recovery
7A) GPU memory headroom returns
bash
Copy code
kubectl exec -n <namespace> -it <pod-name> -- nvidia-smi
7B) Latency stabilizes and batching improves
p95/p99 latency stops climbing

effective batch size increases

fewer timeouts / 503s

If this doesn’t work
If GPU memory is not high (>85–90%) but performance is poor, this may not be KV cache pressure.
Go back to:

diagnostics.md to confirm the signature

check CPU saturation / tokenization / networking issues
