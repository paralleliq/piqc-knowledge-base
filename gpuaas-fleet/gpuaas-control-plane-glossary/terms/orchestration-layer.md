# Orchestration Layer

## Definition
The orchestration layer is the part of the control plane that converts governance decisions and plans into concrete, enforceable Kubernetes resources and actions.

It acts as the translation and execution bridge between high-level policy (what should happen) and the execution layer (which actually runs workloads).

If the governance layer decides, the orchestration layer implements.

## Why it matters in GPUaaS
GPU platforms require coordinated changes across multiple systems at once:
- queues and admission
- node provisioning
- quotas and priorities
- traffic routing
- scaling policies

These changes must be applied consistently and safely. The orchestration layer ensures that plans are executed reliably and idempotently, rather than through ad-hoc scripts or manual steps.

Without orchestration, policy decisions cannot be turned into repeatable cluster behavior.

## Responsibilities
- translate plans into Kubernetes artifacts (CRDs, manifests, configs)
- create or update objects such as queues, quotas, node pools, and workloads
- trigger provisioning or scaling actions
- apply changes via GitOps or controllers
- ensure actions are safe, ordered, and retryable
- reconcile desired state with actual cluster state

## Typical actions
- create or modify Kueue queues and quotas
- adjust Karpenter NodePools or create NodeClaims
- submit or gate workloads for admission
- apply taints, affinities, or placement constraints
- update Gateway or Inference routing rules
- cordon, drain, or consolidate nodes

## What it does not do
The orchestration layer does not make policy decisions or enforce scheduling directly. It does not decide who should run or when; it only applies the decisions made by the governance layer.

## Example
The governance layer decides to run a distributed training job that needs 8 GPUs. The orchestration layer:
1. provisions nodes through the autoscaler,
2. waits for readiness,
3. configures admission,
4. submits the workload.

## Related terms
- [Control Plane](./control-plane.md)
- [Governance Layer](./governance-layer.md)
- [Execution Layer](./execution-layer.md)
- [Actuation](./actuation.md)
- [Provisioning](./provisioning.md)
- [Admission Control](./admission-control.md)

