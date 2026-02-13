# Admission Gating

## Definition
Admission gating is the practice of intentionally delaying workload admission until specific conditions are satisfied, such as capacity availability, policy checks, or provisioning readiness.

It acts as a controlled “gate” between workload submission and execution to ensure jobs only start when the system can run them correctly and efficiently.

Instead of:
admit immediately → hope resources appear

Admission gating enforces:
verify conditions → then admit

## Why it matters in GPUaaS
GPU workloads are sensitive to timing and capacity:

- provisioning is slow
- distributed jobs require multiple GPUs simultaneously
- partial starts waste money
- SLAs depend on predictable startup

If workloads are admitted too early:
- pods sit pending
- GPUs idle
- idle ranks appear
- cold starts increase
- costs rise

Admission gating prevents these issues by coordinating admission with real capacity.

## Responsibilities
Admission gating typically ensures:

- sufficient GPUs are available
- required nodes are Ready
- quotas are respected
- policy and tier checks pass
- provisioning is complete
- dependencies (network, storage, drivers) are healthy

Only after these checks does the system allow scheduling.

## Typical behavior
1. workload is submitted
2. enters queue
3. gating checks run:
   - quota OK?
   - capacity ready?
   - provisioning complete?
4. if not ready → remain queued
5. if ready → admit and schedule

This separates submission time from safe execution time.

## Example
A training job requires 8 GPUs.

Without gating:
- job admitted immediately
- nodes provision gradually
- some workers start early and idle

With admission gating:
- wait until all 8 GPUs are ready
- admit once
- all workers start together

Startup is faster and more efficient.

## Relationship to other concepts
- **Admission control** → decides *whether/when* to run
- **Admission gating** → enforces *wait until ready*
- **Gang scheduling** → start all workers together
- **Provisioning** → create the required capacity first

Admission gating coordinates these pieces.

## Common implementations
- queue-based admission systems
- capacity checks before scheduling
- gang provisioning workflows
- admission webhooks or controllers
- policy engines

Modern GPU platforms use gating to avoid reactive startup problems.

## Mental model
Admission gating is the “green light” that only turns on when the road ahead is clear.

It prevents starting work that the system cannot yet support.

## Related terms
- [Admission Control](./admission-control.md)
- [Queue](./queue.md)
- [Provisioning](./provisioning.md)
- [Gang Scheduling](./gang-scheduling.md)
- [Gang Provisioning](./gang-provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
