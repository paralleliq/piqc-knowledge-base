# Queue

## Definition
A queue is a holding area for workloads that are waiting to be admitted to run in the cluster.

Instead of starting immediately, workloads enter a queue where they wait for sufficient capacity, policy approval, and priority conditions before being scheduled.

Queues enable controlled, fair, and predictable admission of workloads.

## Why it matters in GPUaaS
GPU resources cannot always satisfy demand instantly:
- provisioning takes time
- capacity is limited
- multiple tenants compete
- distributed jobs require many GPUs at once

Without queues:
- workloads start prematurely
- partial starts occur
- idle GPUs are wasted
- higher-priority jobs get blocked

Queues prevent these issues by pacing execution and enforcing order.

## Responsibilities
- buffer incoming workloads
- hold jobs until resources are available
- enforce ordering and fairness
- coordinate with admission control
- enable policies such as priority and quotas

## Typical behavior
When a workload is submitted:
1. it enters a queue
2. the system evaluates capacity and policy
3. when conditions are satisfied, it is admitted
4. then it is scheduled onto nodes

Queues decouple submission time from execution time.

## Common policies
- FIFO (first-in-first-out)
- priority-based ordering
- quota-aware scheduling
- gang admission for multi-GPU jobs
- backpressure during congestion

## Example
Three training jobs request 8 GPUs each, but only 8 GPUs are available.

Instead of all starting and failing:
- job A runs
- jobs B and C wait in the queue
- once A finishes, the next job is admitted

This improves utilization and predictability.

## Mental model
A queue is a waiting room between “request” and “run,” ensuring the system stays stable under load.

## Related terms
- [Admission Control](./admission-control.md)
- [LocalQueue](./localqueue.md)
- [ClusterQueue](./clusterqueue.md)
- [Priority Class](./priority-class.md)
- [Fairness](./fairness.md)
- [Gang Scheduling](./gang-scheduling.md)
# Queue

## Definition
TODO: Add concise definition.

## Why it matters in GPUaaS
TODO: Explain impact on scheduling, provisioning, or control plane behavior.

## Related terms
TODO
