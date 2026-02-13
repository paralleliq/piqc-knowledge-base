# Pod Disruption Budget (PDB)

## Definition
A Pod Disruption Budget (PDB) is a Kubernetes policy that limits how many pods of a workload can be voluntarily disrupted at the same time.

It protects availability during planned operations such as upgrades, scaling, or consolidation.

In GPUaaS platforms, a PDB answers:
“How many replicas must stay running while we make changes?”

## Why it matters in GPUaaS
GPU workloads often back:

- inference services with SLAs
- long-running batch jobs
- distributed training jobs
- multi-replica model servers

Operational actions like:

- node drain
- scale-down
- consolidation
- rolling upgrades

can evict pods.

Without protection:
- too many replicas may disappear at once
- traffic fails
- latency spikes
- training jobs collapse
- SLAs are violated

PDBs ensure safe, gradual disruption.

## Responsibilities
A PDB helps:

- maintain minimum availability
- prevent aggressive scale-down
- protect critical services
- coordinate safe upgrades
- reduce blast radius of maintenance
- enforce operational safety

It provides reliability guardrails during change.

## Typical behavior
When a node is drained or pods are evicted:

1. Kubernetes checks PDB
2. if disruption budget allows → eviction proceeds
3. if not → eviction blocked
4. operation waits until replicas recover

This ensures enough pods stay healthy.

## Key fields

### minAvailable
Minimum number of pods that must remain running

Example:
- replicas: 5
- minAvailable: 4  
Only 1 pod can be disrupted at a time

### maxUnavailable
Maximum pods that may be disrupted

Example:
- replicas: 10
- maxUnavailable: 2  
At least 8 must stay running

Only one is used at a time.

## Example
Inference service:
- 6 replicas
- PDB: minAvailable = 5

During node drain:
- only 1 pod evicted at a time
- traffic remains stable

Without PDB:
- multiple pods might be removed simultaneously
- service outage possible

## GPU-specific considerations

### Inference
PDBs are very important:
- protect latency
- avoid capacity drops

### Training (gang jobs)
Often:
- either all pods run or none
- PDBs less useful
- gang scheduling/provisioning more relevant

Thus PDBs are mainly for serving workloads.

## PDB vs autoscaling
- **PDB** → limits disruptions
- **Autoscaler/Drain** → performs disruptions

PDB acts as the safety brake on automated changes.

## Role in the control plane
The control plane may:

- set stricter PDBs for premium tiers
- relax for best-effort tiers
- adjust during maintenance windows
- protect critical services
- integrate with rollout strategies

It balances reliability with operational flexibility.

## Mental model
PDB is the “do not drop below this line” rule that keeps enough replicas alive during changes.

## Related terms
- [Drain](./drain.md)
- [Consolidation](./consolidation.md)
- [Scale Down](./scale-down.md)
- [Horizontal Pod Autoscaler](./horizontal-pod-autoscaler.md)
- [SLA](./sla.md)
- [Inference API](./inference-api.md)
