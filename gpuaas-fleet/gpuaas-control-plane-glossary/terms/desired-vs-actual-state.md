# Desired vs Actual State

## Definition
Desired vs Actual State is a control-plane model where the system continuously compares what *should be true* (desired state) with what *is currently true* (actual state), and takes actions to close the gap between them.

This concept underpins Kubernetes, GitOps, and modern infrastructure controllers.

## Desired State
The intended configuration of the system, typically expressed as:
- policies
- quotas
- workload requests
- scaling targets
- placement constraints
- SLAs/SLOs

Examples:
- Tenant A may use up to 10 GPUs
- Keep 5 H100 nodes warm
- Admit training jobs only when all GPUs are ready
- Maintain ≥ 95% utilization

Desired state is declarative — it describes *what should happen*, not how.

## Actual State
The real-time condition of the platform, observed from:
- running pods and jobs
- allocated GPUs
- node availability
- queue depth
- utilization metrics
- failures or health signals

Examples:
- 14 GPUs currently allocated
- 3 nodes not Ready
- queue backlog growing
- GPUs sitting idle

Actual state is dynamic and constantly changing.

## Why it matters in GPUaaS
GPU fleets experience frequent drift due to:
- jobs starting and finishing
- autoscaling delays
- preemptions
- spot interruptions
- hardware failures
- uneven placement and fragmentation

Without continuously comparing desired and actual state, the platform:
- violates quotas
- wastes capacity
- misses SLAs
- becomes unpredictable

This model enables the control plane to automatically detect and correct these issues.

## How it works
1. Observe actual state
2. Compare with desired state
3. Detect drift
4. Plan corrective actions
5. Actuate changes
6. Repeat

This cycle forms the foundation of the reconciliation loop.

## Example
Desired:
“Provision 8 GPUs before admitting the training job.”

Actual:
Only 5 GPUs are ready.

Action:
Delay admission and provision 3 more nodes until capacity matches intent.

## Mental model
Desired state defines policy and intent.  
Actual state reflects reality.  
The control plane’s job is to continuously converge reality toward intent.

## Related terms
- [Control Plane](./control-plane.md)
- [Governance Layer](./governance-layer.md)
- [Reconciliation Loop](./reconciliation-loop.md)
- [Actuation](./actuation.md)
- [Provisioning](./provisioning.md)

