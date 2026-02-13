# Inference API

## Definition
Inference API refers to the service interface and platform components that expose deployed machine learning models for real-time or batch inference.

It defines how clients send requests to models and receive predictions, typically over HTTP or gRPC.

In GPUaaS platforms, the Inference API is the layer that turns GPU-backed models into consumable services.

It answers:
“How do users actually call the model?”

## Why it matters in GPUaaS
Most GPUaaS tenants ultimately want to serve models:

- LLM chat/completions
- embeddings
- image/video generation
- recommendation models
- batch scoring

Without a standardized inference interface:
- deployments are inconsistent
- routing is messy
- scaling is manual
- observability is fragmented
- multi-tenancy is harder

An Inference API provides a consistent, production-ready serving surface.

## Responsibilities
An inference layer typically handles:

- exposing model endpoints
- request routing
- load balancing across replicas
- autoscaling triggers
- batching requests
- concurrency limits
- authentication and rate limits
- observability (latency, throughput, errors)

It bridges networking and GPU execution.

## Typical behavior
1. client sends request to endpoint
2. Gateway routes traffic
3. Inference service receives request
4. request processed by model server on GPU
5. response returned

Scaling and placement happen transparently underneath.

## Common components
Inference APIs often integrate with:

- model servers (vLLM, Triton, TGI, etc.)
- Gateway API for routing
- HPA for replica scaling
- autoscaler for node provisioning
- metrics/alerting for SLOs

These systems work together to keep latency and throughput stable.

## Example
A tenant deploys an LLM.

Platform exposes:
- `POST /v1/chat/completions`

Behind the scenes:
- multiple GPU pods serve traffic
- HPA scales replicas with demand
- autoscaler provisions nodes if needed
- Gateway routes requests

Users only see a simple API.

## Role in the control plane
The control plane may:

- deploy new inference services
- create routes
- configure scaling rules
- enforce quotas or limits
- shift traffic during upgrades
- monitor SLOs

Thus, inference APIs are often the actuation target for “deploy model” workflows.

## Inference vs training
- **Inference** → latency-sensitive, elastic scaling, many small requests
- **Training** → large batch jobs, fixed resources, long-running

Inference APIs primarily serve the former.

## Mental model
Inference API is the “front door” where users interact with GPU-backed models, while the control plane manages everything behind the scenes.

## Related terms
- [Gateway API](./gateway-api.md)
- [Horizontal Pod Autoscaler](./horizontal-pod-autoscaler.md)
- [Provisioning](./provisioning.md)
- [GPU Utilization](./gpu-utilization.md)
- [Execution Layer](./execution-layer.md)
