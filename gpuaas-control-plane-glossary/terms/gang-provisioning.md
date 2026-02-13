# Gang Provisioning

## Definition
Gang provisioning is a capacity strategy where all required nodes for a distributed workload are provisioned first and only after the full set is ready is the workload admitted to run.

It combines provisioning and admission into an all-or-nothing process.

Instead of:
admit → provision gradually

It follows:
provision fully → then admit

## Why it matters in GPUaaS
Large GPU workloads — especially distributed training — require many workers to start simultaneously.

If nodes arrive one at a time:
- early workers idle
- GPUs sit unused
- synchronization barriers block progress
- jobs may timeout or fail

Gang provisioning avoids these issues by ensuring that the complete set of capacity exists before any worker starts.

This is critical for:
- PyTorch DDP
- Horovod / MPI jobs
- multi-node training
- large inference shards

## Responsibilities
- calculate total capacity required
- request all nodes together
- wait for readiness of the full set
- only then signal admission
- optionally roll back if any node fails

It coordinates closely with admission control.

## Typical behavior
1. workload requests 8 GPUs
2. system creates 8 NodeClaims (or equivalent)
3. waits until all nodes are Ready
4. admits the workload
5. all pods start simultaneously

If provisioning fails:
- admission is delayed or cancelled

No partial start occurs.

## Example
Without gang provisioning:
- 3 nodes ready → 3 workers start
- 5 still pending → idle ranks
- wasted GPU time

With gang provisioning:
- wait for all 8 nodes
- then start all workers together
- no idle or partial execution

## Relationship to scheduling
- **Gang scheduling** controls admission behavior
- **Gang provisioning** controls capacity creation

Together they ensure synchronized, efficient startup.

## Mental model
Gang provisioning treats capacity as an atomic unit: either all resources exist or none are used.

## Related terms
- [Gang Scheduling](./gang-scheduling.md)
- [Provisioning](./provisioning.md)
- [Admission Control](./admission-control.md)
- [NodeClaim](./nodeclaim.md)
- [Proactive Scaling](./proactive-scaling.md)

