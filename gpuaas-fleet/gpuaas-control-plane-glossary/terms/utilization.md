# Utilization

## Definition
Utilization is the percentage of available resources that are actively doing useful work over a given period of time.

In GPUaaS platforms, it typically refers to how much of the GPU fleet is actually executing workloads versus sitting idle.

Utilization answers:
“How efficiently are we using our hardware?”

## Why it matters in GPUaaS
GPUs are expensive assets. Idle GPUs directly translate into wasted money.

Low utilization means:
- over-provisioning
- poor scheduling
- fragmentation
- unnecessary cost

Very high utilization may mean:
- long queues
- contention
- SLA risk
- insufficient capacity

Healthy utilization balances efficiency with responsiveness.

## Responsibilities
Utilization metrics help the control plane:

- detect idle or wasted capacity
- trigger consolidation or scale-down
- inform provisioning decisions
- evaluate bin packing effectiveness
- guide cost optimization
- measure fleet efficiency

It is one of the most important signals for platform operators.

## Typical measurements

### GPU-level
- GPU compute utilization (%)
- memory utilization
- active vs idle time

### Node-level
- GPUs used / total GPUs
- node occupancy

### Fleet-level
- total allocated GPUs / total GPUs
- average utilization across pools

### Per-tenant
- tenant GPU usage
- share of fleet consumed

## Example
Cluster:
- 100 GPUs total
- 65 actively running workloads

Fleet utilization = 65%

If utilization drops to 30%, the system may consolidate or scale down.
If it rises to 98% with growing queues, the system may scale up.

## Trade-offs
- **Too low** → wasted cost
- **Too high** → poor latency and long waits

Many platforms target a middle ground (e.g., 70–85%) to balance efficiency and responsiveness.

## Mental model
Utilization is the “efficiency gauge” of the fleet — how much of your expensive hardware is actually working.

## Related terms
- [Metrics](./metrics.md)
- [Fragmentation](./fragmentation.md)
- [Bin Packing](./bin-packing.md)
- [Consolidation](./consolidation.md)
- [Provisioning](./provisioning.md)

