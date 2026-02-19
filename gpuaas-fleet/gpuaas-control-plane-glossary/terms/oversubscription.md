# Oversubscription

## Definition
Oversubscription is the practice of allocating more logical or scheduled resources than the physical hardware capacity, based on the expectation that not all workloads will fully utilize their resources at the same time.

It intentionally “overbooks” capacity to increase overall utilization and efficiency.

In GPUaaS platforms, oversubscription answers:
“How can we safely run more work than the raw hardware count suggests?”

## Why it matters in GPUaaS
GPU workloads rarely use 100% of resources continuously:

- inference traffic fluctuates
- batch jobs have idle phases
- some models underutilize compute
- memory or compute may be partially idle

If the platform only schedules up to strict physical limits:
- GPUs sit idle
- utilization stays low
- costs rise

Oversubscription allows higher effective utilization and better ROI.

## Responsibilities
Oversubscription strategies aim to:

- improve utilization
- reduce idle capacity
- increase throughput
- lower cost per workload
- safely multiplex resources
- maintain acceptable performance

It balances efficiency against performance risk.

## Typical approaches

### Time-based
More jobs scheduled than GPUs, assuming staggered usage.

### Replica-based
More inference replicas than GPUs, assuming bursty traffic.

### Memory-based
Allow multiple workloads if combined memory fits.

### Fractional GPUs / MIG
Split GPUs into smaller slices to host multiple jobs.

### Soft limits
Allow temporary overcommit with throttling.

Each approach trades strict guarantees for efficiency.

## Typical behavior
Example:

Cluster:
- 10 GPUs

Workloads:
- each uses ~40% average utilization

Platform may:
- schedule 15–20 workloads
- rely on natural variance

If demand spikes:
- some jobs queue or throttle

This increases average utilization without adding hardware.

## Example
Inference service:

- average GPU utilization: 35%

Platform:
- runs 3 replicas per GPU

During low load:
- high efficiency

During spikes:
- autoscaler provisions more GPUs

Oversubscription smooths the baseline.

## Risks
Oversubscription can cause:

- latency spikes
- contention
- noisy neighbors
- OOM errors
- SLA breaches

It must be applied carefully, often tier-dependent.

Premium or training tiers usually avoid heavy oversubscription.

## Oversubscription vs overcommit
Often used interchangeably, but:

- **Oversubscription** → scheduling more workloads than capacity
- **Overcommit** → allowing resource limits to exceed physical resources

Both rely on probabilistic usage patterns.

## Role in the control plane
The control plane may:

- apply oversubscription per tier
- enforce limits via quotas
- monitor utilization
- reduce overcommit during peaks
- disable for critical workloads

Policies determine where it is safe.

## Mental model
Oversubscription is like airline overbooking — assume not everyone uses full capacity at once to maximize efficiency.

## Related terms
- [Utilization](./utilization.md)
- [Bin Packing](./bin-packing.md)
- [Fragmentation](./fragmentation.md)
- [Quota](./quota.md)
- [GPU Utilization](./gpu-utilization.md)
- [Cost Optimization](./cost-optimization.md)
