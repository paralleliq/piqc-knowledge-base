# Events

## Definition
Events are discrete, time-stamped signals that indicate something happened in the system.

Unlike metrics (continuous measurements), events represent specific state changes or actions, such as a pod failing, a node becoming NotReady, or a job being admitted.

In GPUaaS platforms, events provide real-time visibility into what the cluster is doing.

## Why it matters in GPUaaS
GPU systems are highly dynamic:

- workloads start and stop
- nodes provision and terminate
- queues admit or reject jobs
- failures occur
- policies trigger actions

Metrics show trends, but events explain *what actually happened and when*.

They are essential for:
- debugging
- auditing
- automation triggers
- incident response

Without events, you know something is wrong, but not why.

## Responsibilities
Event systems typically:

- record state transitions
- log lifecycle actions
- capture failures or anomalies
- provide context for decisions
- feed automation and alerting
- support observability and audits

They complement metrics and logs.

## Typical examples

### Scheduling
- pod pending
- pod scheduled
- admission approved/denied
- preemption triggered

### Provisioning
- node requested
- node ready
- node terminated
- provisioning failure

### Runtime
- container crash
- GPU unhealthy
- job completed/failed

### Policy
- quota exceeded
- reclaim executed
- SLA breach detected

Each event explains a specific occurrence.

## Typical behavior
1. action or change occurs
2. system emits event
3. event stored or streamed
4. consumed by:
   - operators (debugging)
   - alerting systems
   - control-plane automation
   - audit logs

Events often trigger immediate reactions.

## Example
Queue depth spikes and jobs are blocked.

Events show:
