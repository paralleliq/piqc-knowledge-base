# Placement Constraints

## Definition
Placement constraints are rules or policies that control where workloads are allowed or preferred to run within a cluster.

They restrict or guide scheduling decisions based on hardware, topology, performance, or isolation requirements.

In GPUaaS platforms, placement constraints answer:
“Which nodes are suitable for this workload?”

## Why it matters in GPUaaS
GPU fleets are heterogeneous:

- different GPU types (H100, A100, T4)
- different memory sizes
- zones/regions
- NVLink or PCIe topology
- spot vs on-demand nodes
- shared vs dedicated pools

If workloads are scheduled anywhere:

- performance may degrade
- jobs may fail
- costs increase
- fragmentation grows
- compliance or isolation is violated

Placement constraints ensure correctness, efficiency, and predictability.

## Responsibilities
Placement constraints help the platform:

- match workloads to compatible GPU shapes
- enforce isolation between tenants
- reduce cross-zone latency
- optimize cost (cheap nodes for best-effort)
- maintain topology for distributed jobs
- avoid unhealthy or restricted nodes
- reduce fragmentation

They provide guardrails for the scheduler.

## Common mechanisms

### Node labels
Tag nodes with attributes (gpu=h100, tier=premium, zone=us-west-2a)

### Node selectors
Require pods to run on matching labels

### Node affinity
Prefer or require specific nodes

### Anti-affinity
Avoid certain nodes or co-location

### Taints and tolerations
Prevent workloads from running unless explicitly allowed

### Topology constraints
Keep pods close (same node/rack/zone)

These are standard Kubernetes tools used to express constraints.

## Typical behavior
1. workload specifies requirements
2. scheduler filters nodes
3. only eligible nodes considered
4. best-fit node selected

If no node satisfies constraints:
- job waits
- or provisioning is triggered

Constraints shape placement before scheduling occurs.

## Example
Training job requires:
- 8 GPUs
- NVLink-connected nodes
- same availability zone

Constraints:
- gpu=h100
- topology=nvlink
- zone=us-west-2a

Scheduler places pods only on matching nodes, ensuring performance.

