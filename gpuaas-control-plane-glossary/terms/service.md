# Service

## Definition
A Service is a Kubernetes resource that provides a stable network endpoint and load-balanced access to a set of pods.

It abstracts away individual pod IPs and lifecycle changes, allowing clients to reliably reach workloads.

In GPUaaS platforms, Services expose GPU-backed applications such as inference servers or control-plane components.

It answers:
“How do clients consistently talk to these pods?”

## Why it matters in GPUaaS
GPU workloads are dynamic:

- pods scale up/down
- replicas restart
- nodes change
- pods move between nodes

Without a stable abstraction:
- clients would need to track pod IPs
- connections break during scaling
- deployments become brittle

Services provide a consistent, resilient endpoint independent of pod churn.

## Responsibilities
A Service typically:

- assigns a stable virtual IP or DNS name
- routes traffic to healthy pods
- load balances requests
- performs basic health checks
- supports scaling transparently
- decouples clients from pod lifecycle

It handles service discovery and connectivity.

## Typical behavior
1. pods are labeled (e.g., app=llm-server)
2. Service selects matching pods
3. client sends traffic to Service
4. traffic routed to one of the pods
5. pods can scale or restart without breaking clients

This enables elastic workloads.

## Common types

### ClusterIP
Internal-only access inside the cluster

### NodePort
Exposes service via node IP and port

### LoadBalancer
Cloud load balancer provisioned externally

### Headless
Direct pod discovery without load balancing

Different types suit different exposure needs.

## Example
Inference deployment:

- 5 replicas of model server
- Service: `chat-api`

Clients call:
- `chat-api.default.svc.cluster.local`

Service automatically distributes traffic across replicas.

If replicas scale to 10:
- no client changes required

## Role in the control plane
The control plane may:

- create Services during deployment
- connect Services to Gateway API routes
- manage scaling policies
- update traffic during rollouts
- remove Services during teardown

Services are often part of the actuation layer.

## Service vs Gateway
- **Service** → internal load balancing and discovery
- **Gateway API** → external traffic routing and policies

Gateway routes traffic to Services, which then route to pods.

## Mental model
A Service is the “stable address” for a group of pods — clients talk to the name, not the instances.

## Related terms
- [Gateway API](./gateway-api.md)
- [Load Balancing](./load-balancing.md)
- [Inference API](./inference-api.md)
- [Horizontal Pod Autoscaler](./horizontal-pod-autoscaler.md)
- [Execution Layer](./execution-layer.md)
