# Intent

## Definition
Intent is a high-level declaration of what outcome the user or platform wants to achieve, without specifying the exact steps to achieve it.

It expresses the desired goal, not the implementation details.

In GPUaaS control planes, intent separates *what should happen* from *how it happens*.

It answers:
“What do you want the system to accomplish?”

## Why it matters in GPUaaS
GPU platforms are complex:

- many tenants
- multiple GPU types
- dynamic demand
- autoscaling
- fairness rules
- cost trade-offs

If users must manually decide:
- which nodes
- how many
- when to provision
- how to route traffic

the system becomes brittle and hard to operate.

Intent-based design lets users describe outcomes while the control plane handles execution.

This enables automation and portability.

## Responsibilities
Intent systems typically allow users to specify:

- desired GPU count or tier
- performance targets (latency, throughput)
- deployment goals (replicas, availability)
- cost constraints
- scheduling preferences
- policy requirements

The control plane then translates this into concrete actions.

## Typical behavior
1. user declares intent
2. control plane interprets requirements
3. policies and constraints applied
4. plan generated
5. infrastructure and workloads created
6. reconciliation ensures desired state is maintained

Users define goals, not steps.

## Example
Intent:
“I need 10 GPUs on a best-effort tier.”

Control plane decides:
- which pool
- when to provision
- how to queue
- which nodes
- scaling strategy

The user does not manage these details.

## Intent vs configuration
- **Intent** → high-level goal
- **Configuration** → low-level settings

Example:

Intent:
- run model with 99% availability

Configuration:
- replicas=6
- HPA enabled
- warm pool size=2
- route rules configured

Intent is stable; configuration may change dynamically.

## Role in the control plane
Intent is often the starting point for:

- admission decisions
- provisioning plans
- scaling policies
- reconciliation loops

It drives the governance and orchestration layers.

This aligns with declarative systems like Kubernetes and Terraform.

## Mental model
Intent is the “destination,” while the control plane figures out the “route.”

## Related terms
- [Control Plane](./control-plane.md)
- [Governance Layer](./governance-layer.md)
- [Desired vs Actual State](./desired-vs-actual-state.md)
- [Policy Engine](./policy-engine.md)
- [Actuation](./actuation.md)
