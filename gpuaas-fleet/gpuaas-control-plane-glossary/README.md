# GPUaaS Control Plane Glossary

This glossary defines the key concepts, patterns, and components involved in operating a GPU-as-a-Service (GPUaaS) platform and its control plane.

It focuses on the **governance, orchestration, and execution layers** that manage capacity, fairness, provisioning, and workload admission across shared GPU clusters. These terms describe how modern platforms translate user intent into reliable, cost-efficient, and scalable infrastructure behavior.

Use this glossary as a reference when designing or discussing control plane architecture, workflows, and policies.

---

## 🧠 Core Control Plane Concepts
- [Control Plane](terms/control-plane.md)
- [Governance Layer](terms/governance-layer.md)
- [Orchestration Layer](terms/orchestration-layer.md)
- [Execution Layer](terms/execution-layer.md)
- [Reconciliation Loop](terms/reconciliation-loop.md)
- [Desired vs Actual State](terms/desired-vs-actual-state.md)
- [Actuation](terms/actuation.md)

## 🚦 Admission & Scheduling
- [Admission Control](terms/admission-control.md)
- [Queue](terms/queue.md)
- [LocalQueue](terms/localqueue.md)
- [ClusterQueue](terms/clusterqueue.md)
- [Priority Class](terms/priority-class.md)
- [Preemption](terms/preemption.md)
- [Fairness](terms/fairness.md)
- [Quota](terms/quota.md)
- [Resource Quota](terms/resource-quota.md)
- [Gang Scheduling](terms/gang-scheduling.md)

## 🚀 Provisioning & Autoscaling
- [Provisioning](terms/provisioning.md)
- [Reactive Scaling](terms/reactive-scaling.md)
- [Proactive Scaling](terms/proactive-scaling.md)
- [Karpenter](terms/karpenter.md)
- [NodePool](terms/nodepool.md)
- [NodeClaim](terms/nodeclaim.md)
- [Warm Pool](terms/warm-pool.md)
- [Consolidation](terms/consolidation.md)

## 🎯 GPU-Specific Patterns
- [Gang Provisioning](terms/gang-provisioning.md)
- [Idle Rank](terms/idle-rank.md)
- [Fragmentation](terms/fragmentation.md)
- [Bin Packing](terms/bin-packing.md)
- [Cold Start](terms/cold-start.md)
- [GPU Shape](terms/gpu-shape.md)
- [Reclaim](terms/reclaim.md)

## 📊 Telemetry & Signals
- [Metrics](terms/metrics.md)
- [Alertmanager](terms/alertmanager.md)
- [Queue Depth](terms/queue-depth.md)
- [Utilization](terms/utilization.md)
- [SLA](terms/sla.md)
- [SLO](terms/slo.md)

## 🔁 Operational Workflows
- [Tenant Onboarding](terms/tenant-onboarding.md)
- [Capacity Rebalancing](terms/capacity-rebalancing.md)
- [Incident Management](terms/incident-management.md)
- [Cost Optimization](terms/cost-optimization.md)
- [Platform Upgrade](terms/platform-upgrade.md)

---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
