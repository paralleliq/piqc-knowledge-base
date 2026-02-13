# Webhook

## Definition
A webhook is a mechanism that allows one system to send real-time HTTP callbacks to another system when specific events occur.

It enables event-driven integration between components.

In GPUaaS platforms, webhooks allow Kubernetes or monitoring systems to notify the control plane immediately when something changes.

It answers:
“How do we get notified the moment something happens?”

## Why it matters in GPUaaS
GPU platforms must react quickly to events such as:

- queue spikes
- node failures
- spot interruptions
- SLA breaches
- provisioning completion
- workload admission

Polling for changes is slow and inefficient.

Webhooks provide instant, push-based notifications, enabling fast automation and closed-loop control.

## Responsibilities
Webhooks typically:

- receive event notifications
- trigger automation workflows
- integrate external systems
- enforce policies
- connect observability to action
- reduce reaction latency

They glue systems together.

## Typical behavior
1. event occurs
2. source system sends HTTP POST to webhook endpoint
3. control plane receives payload
4. workflow or policy executes

This happens asynchronously and automatically.

## Common sources in GPUaaS

### Kubernetes
- admission webhooks
- lifecycle events
- custom controllers

### Monitoring/Alerting
- alert triggers
- SLA violations
- anomaly detection

### CI/CD or GitOps
- deployment events
- config changes

### Cloud provider
- spot interruption notices
- provisioning state changes

All can feed into the control plane.

## Types

### Admission webhooks
Intercept resource creation/modification  
Used to validate or mutate requests

### Event webhooks
Notify on state changes

### Alert webhooks
Triggered by Alertmanager or monitoring

Different types serve different purposes.

## Example
Queue depth exceeds threshold.

Monitoring system:
- fires alert
- sends webhook

Control plane:
- provisions additional GPUs
- or gates new workloads

Reaction happens within seconds.

## Role in the control plane
The control plane may use webhooks to:

- trigger scaling
- start reconciliation workflows
- enforce policies
- update routing
- initiate incident response
- notify humans

They enable event-driven automation rather than periodic checks.

## Webhook vs polling
- **Webhook** → push-based, real-time
- **Polling** → periodic, slower, resource-heavy

Modern control planes prefer webhooks for responsiveness.

## Mental model
A webhook is a “doorbell” — the system rings you immediately when something happens.

## Related terms
- [Alerting](./alerting.md)
- [Alertmanager](./alertmanager.md)
- [Events](./events.md)
- [Closed Loop Control](./closed-loop-control.md)
- [Reconciliation Loop](./reconciliation-loop.md)
- [Admission Control](./admission-control.md)
