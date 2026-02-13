# Idle Rank

## Definition
An idle rank is a worker process or GPU in a distributed job that has started but cannot make progress because other required workers have not started yet.

It consumes resources but performs no useful computation.

Idle ranks typically occur when a distributed workload starts partially instead of all at once.

## Why it matters in GPUaaS
GPU time is expensive. If some workers start early while others are still pending:

- GPUs sit idle
- synchronization barriers block progress
- jobs stall or timeout
- cost increases without productive work

Even a few idle ranks can waste thousands of dollars during large training runs.

Preventing idle ranks is one of the main reasons for gang scheduling and coordinated provisioning.

## Where it happens
Common in:
- PyTorch DDP
- MPI-based training
- Horovod
- multi-node training
- tightly synchronized inference pipelines

These systems require all workers to participate together.

## Typical behavior
Example: job requires 8 GPUs.

Reactive startup:
1. 3 nodes become ready → 3 workers start
2. workers wait for peers
3. 5 GPUs still pending
4. first 3 GPUs sit idle

Those 3 workers are idle ranks.

## Root causes
- reactive scaling
- staggered provisioning
- lack of gang scheduling
- immediate admission without capacity checks

Any scenario where workers start at different times can create idle ranks.

## How to prevent
- gang scheduling (all-or-nothing admission)
- gang provisioning (provision first, then admit)
- warm pools for faster startup
- proactive scaling

These ensure synchronized startup.

## Mental model
Idle rank = a running GPU that is waiting instead of working.

It is pure waste caused by partial starts.

## Related terms
- [Gang Scheduling](./gang-scheduling.md)
- [Gang Provisioning](./gang-provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Cold Start](./cold-start.md)
- [Provisioning](./provisioning.md)

