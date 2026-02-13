# Metrics

## Definition
Metrics are quantitative measurements that describe the current and historical behavior of the platform.

They provide visibility into capacity, performance, utilization, health, and policy compliance across the cluster.

Metrics answer:
“What is happening right now, and how well is the system performing?”

## Why it matters in GPUaaS
GPU platforms are dynamic and expensive. Without metrics, operators cannot:

- detect idle GPUs
- understand utilization
- spot bottlenecks
- enforce SLAs
- trigger scaling
- diagnose incidents
- optimize costs

Metrics are the foundation for monitoring, alerting, automation, and decision-making in the control plane.

## Responsibilities
- expose real-time resource usage
- measure performance and latency
- track queue depth and backlog
- detect failures and anomalies
- inform scaling and admission decisions
- feed reconciliation loops and policies

The governance and orchestration layers depend on metrics to make informed decisions.

## Common categories

### Capacity
- total GPUs
- allocated GPUs
- free GPUs
- node count
- pool capacity

### Utilization
- GPU utilization (%)
- memory usage
- active vs idle time
- node utilization

### Scheduling
- queue depth
- pending pods
- admission latency
- time-to-start

### Reliability
- node readiness
- job failures
- preemptions
- reclaim events

### Business / platform
- tenant usage
- cost per GPU-hour
- SLA/SLO compliance
- chargeback/consumption

## Example
If GPU utilization drops below 40%:
- consolidation may be triggered

If queue depth exceeds a threshold:
- provisioning or scaling may be triggered

Metrics directly drive automated actions.

## Typical tooling
Metrics are often collected via:
- Prometheus
- exporters
- Kubernetes APIs
- autoscaler signals
- custom collectors

They are then used for dashboards, alerts, and control logic.

## Mental model
Metrics are the “sensors” of the control plane.

Without sensors, the system cannot observe reality or make intelligent decisions.

## Related terms
- [Observability](./observability.md)
- [Alerting](./alerting.md)
- [Reconciliation Loop](./reconciliation-loop.md)
- [Utilization](./utilization.md)
- [SLA](./sla.md)

