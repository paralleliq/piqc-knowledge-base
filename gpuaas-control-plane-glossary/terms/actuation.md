# Actuation

## Definition
Actuation is the process of applying decisions made by the control plane to the underlying system by creating, updating, or deleting concrete resources in the execution layer.

It is how plans become real behavior.

If governance decides *what should happen* and orchestration determines *how to express it*, actuation is the step that *makes it happen*.

## Why it matters in GPUaaS
GPU platforms require coordinated changes across multiple subsystems:
- provisioning nodes
- adjusting quotas
- admitting or delaying workloads
- routing traffic
- reclaiming resources
- draining or consolidating nodes

Without reliable actuation, policies remain theoretical and the cluster drifts away from intent.

Actuation ensures:
- enforcement of tenant contracts
- predictable workload startup
- controlled scaling
- safe remediation during incidents
- consistent and repeatable operations

## Responsibilities
- apply Kubernetes manifests or CRDs
- modify queues, quotas, and priorities
- trigger autoscaler actions (e.g., node provisioning)
- create or gate workloads for admission
- adjust routing and networking rules
- cordon, drain, or consolidate nodes
- retry safely if changes fail

## Common mechanisms
Actuation is typically performed through:
- Kubernetes API calls
- controllers/operators
- GitOps systems
- infrastructure automation

The goal is declarative, idempotent changes rather than imperative scripts.

## Example
Decision:
“Provision 8 GPUs and admit a training job.”

Actuation steps:
1. update NodePool or create NodeClaims
2. wait for nodes to become Ready
3. configure admission
4. submit the workload

## Mental model
Actuation is the hands of the control plane.

It turns intent and plans into observable cluster state.

## Related terms
- [Control Plane](./control-plane.md)
- [Governance Layer](./governance-layer.md)
- [Orchestration Layer](./orchestration-layer.md)
- [Reconciliation Loop](./reconciliation-loop.md)
- [Provisioning](./provisioning.md)

