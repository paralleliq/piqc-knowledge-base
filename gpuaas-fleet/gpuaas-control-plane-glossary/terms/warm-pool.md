# Warm Pool

## Definition
A warm pool is a small reserve of pre-provisioned, ready-to-use nodes that are kept running so workloads can start immediately without waiting for new capacity to be created.

These nodes are already joined to the cluster and available for scheduling.

Instead of provisioning on demand, the system keeps a buffer of “warm” capacity.

## Why it matters in GPUaaS
GPU nodes often take significant time to provision:
- instance launch
- driver setup
- container runtime initialization
- cluster join

This can add tens of seconds or minutes of startup latency.

For:
- interactive workloads
- inference services
- time-sensitive training jobs
- SLA-bound workloads

that delay is unacceptable.

Warm pools reduce cold starts and provide predictable startup times.

## Responsibilities
- maintain a minimum number of ready nodes
- absorb sudden workload spikes
- reduce provisioning latency
- smooth scaling behavior
- act as a buffer between demand and provisioning

Warm pools trade some idle capacity for faster responsiveness.

## Typical behavior
1. system maintains N idle nodes
2. workloads arrive
3. they schedule immediately onto warm nodes
4. autoscaler backfills by provisioning replacements
5. pool returns to target size

This decouples startup time from provisioning time.

## Example
A platform keeps 5 H100 nodes warm.

When a training job requests 4 GPUs:
- it starts immediately
- no provisioning delay
- autoscaler later restores the pool

Without a warm pool, the job would wait for new nodes to be created.

## Trade-offs
Warm pools improve latency but:
- increase short-term cost due to idle no

