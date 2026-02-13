# GPU Utilization

## Definition
GPU utilization is the percentage of time a GPU is actively performing useful computation versus sitting idle.

It measures how effectively GPU hardware is being used.

In GPUaaS platforms, GPU utilization is one of the most important indicators of efficiency and cost performance.

It answers:
“Are our GPUs actually doing work?”

## Why it matters in GPUaaS
GPUs are expensive assets. Idle GPUs directly translate into wasted money.

Low GPU utilization means:
- over-provisioning
- fragmentation
- poor scheduling
- idle ranks
- unnecessary cost

Very high utilization may indicate:
- long queues
- contention
- startup delays
- SLA risk

The goal is high but healthy utilization.

## Responsibilities
GPU utilization helps the control plane:

- detect idle capacity
- trigger consolidation or scale-down
- guide bin packing decisions
- inform capacity planning
- optimize costs
- validate scheduling efficiency
- identify stranded or partially used nodes

It directly influences scaling and optimization workflows.

## Typical measurements

### Device-level
- SM/compute utilization (%)
- memory bandwidth utilization
- active vs idle time

### Node-level
- GPUs allocated / total GPUs
- average GPU busy time

### Fleet-level
- total busy GPUs / total GPUs
- utilization per pool or tenant

These provide different views of efficiency.

## Example
Cluster:
- 100 GPUs total
- 65 actively computing

Fleet GPU utilization = 65%

If utilization drops to 35%:
- consolidate or scale down

If utilization stays near 100% with growing queues:
- provision more capacity

Both extremes signal action.

## Common causes of low utilization
- idle ranks in distributed training
- partial starts
- fragmentation
- oversized nodes
- abandoned jobs
- reactive scaling delays

Fixing these often yields large cost savings.

## Relationship to cost
Improving GPU utilization typically:
- lowers cost per job
- reduces idle GPU hours
- increases ROI on hardware

It is a direct lever for profitability.

## Mental model
GPU utilization is the “efficiency gauge” of the fleet — how much of your most expensive hardware is actually working.

## Related terms
- [Utilization](./utilization.md)
- [Fragmentation](./fragmentation.md)
- [Bin Packing](./bin-packing.md)
- [Idle Rank](./idle-rank.md)
- [Cost Optimization](./cost-optimization.md)
- [Provisioning](./provisioning.md)
