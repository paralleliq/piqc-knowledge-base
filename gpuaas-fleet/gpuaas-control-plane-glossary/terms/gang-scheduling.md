# Gang Scheduling

## Definition
Gang scheduling is a scheduling strategy where a group of related workloads must be admitted and started together as a single unit, rather than independently.

If the full set of required resources is not available, none of the workloads start.

It enforces an all-or-nothing startup model.

## Why it matters in GPUaaS
Many GPU workloads, especially distributed training jobs, require multiple workers that must run simultaneously.

Examples include:
- PyTorch DDP
- Horovod
- MPI-based jobs
- large batch pipelines

If only some workers start while others wait, the job can:
- stall at synchronization barriers
- waste GPUs (idle ranks)
- timeout or fail
- incur unnecessary cost

Gang scheduling prevents partial starts and ensures synchronized execution.

## Responsibilities
- treat related pods or workers as a single unit
- delay admission until all required resources are available
- admit and start the entire group together
- avoid partial or staggered startup

## Typical behavior
When a job requests 8 GPUs:
1. scheduler checks if all 8 GPUs are available
2. if yes → admit and start all workers
3. if no → wait (do not start any)

This avoids early or fragmented execution.

## Example
A training job needs 8 GPUs.

Without gang scheduling:
- 3 workers start
- 5 wait
- early workers idle or timeout

With gang scheduling:
- none start until all 8 are ready
- all workers launch together

This improves reliability and utilization.

## Relationship to provisioning
Gang scheduling often requires coordination with provisioning:
- provision capacity first
- then admit

This pattern is sometimes called gang provisioning or admission gating.

## Mental model
Gang scheduling treats a distributed job as one atomic block instead of many independent pods.

Either everyone runs, or no one runs.

## Related terms
- [Gang Provisioning](./gang-provisioning.md)
- [Admission Control](./admission-control.md)
- [Queue](./queue.md)
- [Idle Rank](./idle-rank.md)
- [Provisioning](./provisioning.md)

