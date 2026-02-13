# Platform Upgrade

## Definition
Platform upgrade is the process of safely updating the underlying infrastructure, software stack, or control plane components of the GPUaaS platform without disrupting tenant workloads or violating SLAs.

It includes upgrades to Kubernetes, drivers, runtimes, autoscalers, networking, and control-plane services.

In GPUaaS, platform upgrade answers:
“How do we improve or patch the system without breaking running jobs?”

## Why it matters in GPUaaS
GPU platforms depend on many fast-moving components:

- Kubernetes versions
- GPU drivers (CUDA/NVIDIA/ROCm)
- device plugins
- autoscalers
- networking stacks
- control-plane services

Upgrades are necessary for:
- security patches
- performance improvements
- new hardware support
- bug fixes
- feature delivery

But careless upgrades can:
- interrupt long training jobs
- cause node crashes
- break scheduling
- violate SLAs
- create costly downtime

Safe, controlled upgrades are critical for reliability.

## Responsibilities
Platform upgrades typically involve:

- rolling node updates
- draining and replacing nodes
- validating compatibility
- upgrading control-plane services
- testing and staging
- minimizing disruption to tenants
- maintaining service guarantees

They must be repeatable and automated.

## Typical workflow
1. new version validated in staging
2. nodes cordoned
3. workloads drained or migrated
4. nodes replaced or updated
5. new nodes join cluster
6. health checks verify stability
7. rollout continues gradually

This is often called a rolling or blue/green upgrade.

## Example
Upgrading GPU drivers:

- cordon node
- drain running pods
- update driver image
- reboot node
- return to Ready
- repeat across fleet

This prevents workload crashes.

## Best practices
- rolling upgrades (small batches)
- disruption budgets
- maintenance windows for lower tiers
- prioritize non-SLA pools first
- automated rollback
- canary testing

These reduce risk and downtime.

## Mental model
Platform upgrades are “surgery while the system is running” — changes must be gradual, controlled, and minimally disruptive.

## Related terms
- [Drain](./drain.md)
- [Cordon](./cordon.md)
- [Incident Management](./incident-management.md)
- [SLA](./sla.md)
- [Reconciliation Loop](./reconciliation-loop.md)

