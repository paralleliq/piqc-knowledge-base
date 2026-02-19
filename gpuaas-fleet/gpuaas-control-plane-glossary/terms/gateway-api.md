# Gateway API

## Definition
Gateway API is a Kubernetes-native set of resources for configuring and managing network traffic into and within a cluster.

It provides a standardized, extensible way to define how external and internal traffic is routed to services.

In GPUaaS platforms, Gateway API controls how users and applications reach inference endpoints and services running on GPUs.

It answers:
“How does traffic get to the right workload?”

## Why it matters in GPUaaS
Most GPU workloads expose services:

- model inference APIs
- batch endpoints
- internal microservices
- control-plane services

These require:

- routing
- load balancing
- TLS termination
- multi-tenant isolation
- traffic shaping

Without a structured gateway layer:
- routing is inconsistent
- security is weaker
- scaling is harder
- multi-tenancy becomes messy

Gateway API provides a clean, declarative networking abstraction.

## Responsibilities
Gateway API typically handles:

- exposing services externally
- routing traffic to specific backends
- path/host-based routing
- TLS configuration
- traffic splitting and canaries
- multi-tenant separation
- policy enforcement

It manages traffic flow, not compute capacity.

## Core concepts

### Gateway
Represents the entry point (load balancer / ingress).

### HTTPRoute / GRPCRoute / TCPRoute
Defines how traffic is routed to services.

### BackendRef
Points to services or workloads that receive traffic.

### Policies
Control timeouts, retries, rate limits, etc.

Together these define how requests reach pods.

## Typical behavior
1. user sends request to endpoint
2. Gateway receives traffic
3. routing rules match host/path
4. request forwarded to service
5. pods process the request

Scaling or failover happens transparently.

## Example
Two models:

- /chat → LLM service
- /embed → embedding service

Gateway API routes:
- /chat → service A
- /embed → service B

Both may run on different GPU pools.

## Role in the control plane
Gateway API often sits at the boundary between:

- orchestration layer (configure routes)
- execution layer (serve traffic)

The control plane may:

- create routes during deployment
- shift traffic during rollouts
- disable routes during incidents
- implement canary releases

It connects deployment decisions to real user traffic.

## Gateway API vs Ingress
- **Ingress** → older, simpler, limited flexibility
- **Gateway API** → newer, more expressive, multi-tenant friendly

Modern platforms prefer Gateway API for advanced routing.

## Mental model
Gateway API is the “traffic controller” that directs requests to the right GPU-backed services.

## Related terms
- [Service](./service.md)
- [Inference API](./inference-api.md)
- [Load Balancing](./load-balancing.md)
- [Execution Layer](./execution-layer.md)
- [Observability](./observability.md)

