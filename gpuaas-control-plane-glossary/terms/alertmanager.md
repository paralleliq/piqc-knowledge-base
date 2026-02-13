# Alertmanager

## Definition
Alertmanager is the component in the Prometheus ecosystem that receives alerts from monitoring systems, groups and routes them, and sends notifications to external systems such as email, Slack, PagerDuty, or webhooks.

It turns raw metric thresholds into actionable signals.

In GPUaaS platforms, Alertmanager acts as the notification bridge between the execution layer and the control plane or operators.

## Why it matters in GPUaaS
GPU fleets are dynamic and failure-prone:

- nodes fail or go NotReady
- queues back up
- utilization drops
- SLAs are breached
- jobs stall
- capacity runs out

The control plane cannot constantly poll everything. Instead, it needs immediate signals when something abnormal happens.

Alertmanager enables event-driven reactions rather than only periodic checks.

## Responsibilities
- receive alerts from Prometheus
- deduplicate repeated alerts
- group related alerts
- apply routing rules
- suppress noise
- send notifications to humans or systems
- trigger automation via webhooks

It focuses on delivery and routing, not detection.

## Typical behavior
1. metrics cross a threshold (e.g., queue depth > 100)
2. Prometheus fires an alert
3. Alertmanager receives it
4. alerts are grouped or deduplicated
5. notification is sent to:
   - Slack
   - PagerDuty
   - email
   - webhook to control plane

This enables fast response.

## Example use cases
Common GPUaaS alerts:

- high queue depth
- GPU utilization below target
- node provisioning failures
- node NotReady
- SLA/SLO breaches
- excessive preemption
- reclaim events

These alerts may trigger:
- automated scaling
- reconciliation actions
- operator intervention

## Relationship to control plane
Alertmanager often sends alerts to:

- humans (on-call engineers)
- automation workflows
- control-plane webhooks

This allows the governance layer to react quickly to runtime conditions.

Example:
Queue depth spike → webhook → scale-up workflow.

## Mental model
Alertmanager is the “dispatcher” that delivers important signals from the system to the right place at the right time.

Metrics detect problems; Alertmanager makes sure someone or something responds.

## Related terms
- [Metrics](./metrics.md)
- [Alerting](./alerting.md)
- [Webhook](./webhook.md)
- [Observability](./observability.md)
- [Reconciliation Loop](./reconciliation-loop.md)

