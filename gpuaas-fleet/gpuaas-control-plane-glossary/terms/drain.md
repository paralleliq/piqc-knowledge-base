# Drain

## Definition
Drain is the process of safely evicting all running workloads from a node so it can be removed, upgraded, or taken out of service.

It gracefully migrates or stops workloads rather than abruptly terminating them.

In simple terms: empty the node before touching it.

## Why it matters in GPUaaS
GPU workloads are often:

- long-running
- expensive
- stateful
- distributed

Forcefully killing a node can:
- waste hours or days of training
- lose progress
- violate SLAs
- create costly retries

Draining allows the platform to move or stop workloads in a controlled way, minimizing disruption and cost.

It is critical for safe operations and maintenance.

## Responsibilities
Draining typically:

- marks the node unschedulable (cordon)
- evicts running pods
- respects disruption budgets
- waits for graceful shutdowns
- ensures workloads are rescheduled elsewhere
- frees the node for maintenance or termination

It protects workload integrity during changes.

## Typical behavior
When a node is drained:

1. node is cordoned (no new pods)
2. pods are evicted
3. scheduler places them on other nodes
4. node becomes empty
5. node can be upgraded, replaced, or deleted

Draining moves work off safely before any disruptive action.

## Example
Scaling down a GPU pool:

- select underutilized node
- cordon
- drain workloads
- terminate node

This avoids interrupting active jobs abruptly.

## Drain vs Cordon
- **Cordon** → stop new placements only
- **Drain** → evict existing workloads

Typical sequence:
cordon → drain → upgrade/remove

Cordoning protects future placements; draining handles current ones.

## Common use cases
- rolling upgrades
- driver or OS updates
- node replacement
- consolidation
- scaling down
- hardware failures

These operations depend on draining for safety.

## Trade-offs
Draining may:
- temporarily reschedule workloads
- cause brief performance impact
- require careful coordination for large distributed jobs

Platforms often use disruption budgets to limit impact.

## Mental model
Drain is the “clear the room” step before maintenance — move everything out safely before making changes.

## Related terms
- [Cordon](./cordon.md)
- [Consolidation](./consolidation.md)
- [Scale Down](./scale-down.md)
- [Platform Upgrade](./platform-upgrade.md)
- [Incident Management](./incident-management.md)
