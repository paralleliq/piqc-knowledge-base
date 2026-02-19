# Spot Interruption

## Definition
Spot interruption is the event where a cloud provider reclaims a spot (preemptible) instance, terminating it with little or no notice.

It occurs because spot capacity is offered at lower cost but without availability guarantees.

In GPUaaS platforms, a spot interruption answers:
“This node is going away soon — how do we react safely?”

## Why it matters in GPUaaS
Spot GPUs are attractive because they are significantly cheaper than on-demand or reserved instances.

However, they:

- can disappear at any time
- often provide only short warnings (e.g., 30–120 seconds)
- may terminate many nodes simultaneously

Without handling interruptions:

- jobs crash
- training progress is lost
- inference capacity drops suddenly
- SLAs are violated
- users lose trust

Spot capacity reduces cost but increases operational risk.

## Responsibilities
A platform must:

- detect interruption signals
- stop scheduling new work on affected nodes
- gracefully drain workloads
- reschedule or checkpoint jobs
- provision replacement capacity
- maintain availability

Proper handling turns unpredictable loss into controlled recovery.

## Typical behavior
When interruption notice arrives:

1. cloud signals termination
2. node is cordoned
3. workloads drained or checkpointed
4. jobs rescheduled elsewhere
5. autoscaler provisions replacement nodes

If handled quickly, users may not notice disruption.

## Example
Cluster uses 20 spot GPUs for best-effort jobs.

Cloud reclaims 5 nodes:

- workloads drained
- remaining jobs requeued
- autoscaler provisions new spot/on-demand nodes

Best-effort workloads may slow, but premium tiers remain unaffected.

## Common strategies

### Tier-based placement
- spot → best-effort
- on-demand → premium/SLA

### Checkpointing
Save training progress frequently

### Admission control
Avoid starting long jobs on spot

### Diversified pools
Spread across instance types/zones

### Rapid replacement
Fast autoscaling to backfill capacity

These reduce interruption impact.

## Spot vs on-demand
- **Spot** → cheaper, interruptible
- **On-demand/reserved** → stable, more expensive

Platforms mix both to balance cost and reliability.

## Role in the control plane
The control plane may:

- assign workloads to spot vs stable pools
- monitor interruption events
- trigger drain workflows
- automatically requeue jobs
- protect premium tiers
- adjust pricing and policies

It manages risk exposure strategically.

## Mental model
Spot instances are “discount seats” — cheaper but can be taken away at any time, so you must be ready to move quickly.

## Related terms
- [Cordon](./cordon.md)
- [Drain](./drain.md)
- [Provisioning](./provisioning.md)
- [Scale Up](./scale-up.md)
- [Scale Down](./scale-down.md)
- [Reservation](./reservation.md)
- [Incident Management](./incident-management.md)
