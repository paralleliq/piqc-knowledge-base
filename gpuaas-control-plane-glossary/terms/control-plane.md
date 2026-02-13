# Control Plane

## Definition
The control plane is the decision-making layer that translates user intent (e.g., tier, quota, SLA/SLO, budget, compliance constraints) into concrete actions in the underlying platform (Kubernetes, schedulers, autoscalers, gateways, and runtimes).

In a GPUaaS platform, the control plane is responsible for coordinating *multiple* cluster subsystems (admission, provisioning, placement, routing, and enforcement) so that the fleet behaves predictably under multi-tenant demand.

## Why it matters in GPUaaS
GPU workloads amplify common cluster problems: long provisioning times, expensive idle capacity, fragmentation, and distributed training “all-or-nothing” startup requirements. A control plane provides a single place to:
- enforce tenant contracts (tiers, quotas, limits, isolation)
- coordinate admission with provisioning (e.g., provision → ready → admit for training)
- manage reclaim/preemption policies safely across tenants
- optimize utilization and cost across GPU pools
- react to incidents and degradations using policy-driven remediation

Without a control plane, these behaviors are either left to default Kubernetes mechanics (often insufficient for GPUs) or implemented as scattered scripts and ad-hoc automation.

## Typical responsibilities
- **Intent management:** capture what tenants requested and what they are allowed to use
- **Policy evaluation:** decide what should happen given current state and constraints
- **Planning:** produce a concrete plan (e.g., allocate from pool X, scale nodepool Y, route traffic via gateway Z)
- **Actuation:** apply the plan to the cluster (GitOps/controllers)
- **Observation:** ingest facts and triggers (metrics, events, queue depth, health) and reconcile continuously
- **Auditability:** record decisions, actions taken, and outcomes for traceability

## Interfaces (common in practice)
- **Northbound (tenant-facing):** portal/API/CLI for requesting capacity, deploying models, viewing usage/SLA
- **Southbound (cluster-facing):** Kubernetes API (CRDs), Kueue, Karpenter, Gateway API, Inference API, metrics/alerts

## Related terms
- [Governance Layer](./governance-layer.md)
- [Orchestration Layer](./orchestration-layer.md)
- [Execution Layer](./execution-layer.md)
- [Reconciliation Loop](./reconciliation-loop.md)
- [Desired vs Actual State](./desired-vs-actual-state.md)
- [Actuation](./actuation.md)
- [Admission Control](./admission-control.md)
- [Provisioning](./provisioning.md)
- [Closed Loop Control](./closed-loop-control.md)

