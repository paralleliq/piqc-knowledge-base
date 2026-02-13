# Traffic Shaping

## Definition
Traffic shaping is the practice of controlling how requests are distributed, prioritized, throttled, or limited across services to ensure predictable performance, fairness, and efficient resource usage.

It regulates the flow of traffic rather than simply forwarding it.

In GPUaaS platforms, traffic shaping answers:
“How should requests be paced and prioritized so GPUs aren’t overwhelmed?”

## Why it matters in GPUaaS
GPU-backed services — especially inference — can be easily overloaded:

- sudden request spikes
- large prompts or payloads
- uneven tenant usage
- bursty workloads

Without traffic shaping:

- latency spikes
- GPU queues explode
- OOM errors occur
- tail latency worsens
- SLAs break
- noisy neighbors dominate

Traffic shaping protects system stability and fairness.

## Responsibilities
Traffic shaping typically:

- limit request rates
- prioritize important traffic
- queue or delay excess requests
- smooth bursts
- isolate tenants
- prevent overload
- maintain SLOs

It helps keep demand aligned with available capacity.

## Common techniques

### Rate limiting
Cap requests per second per tenant or API key

### Throttling
Slow down request processing under load

### Queuing
Buffer excess requests instead of rejecting

### Priority routing
Premium or critical traffic served first

### Weighted routing
Split traffic proportionally across replicas or pools

### Circuit breaking
Reject requests when systems are unhealthy

Each technique balances fairness, reliability, and cost.

## Typical behavior
1. requests arrive
2. gateway or service evaluates policies
3. apply limits or prioritization
4. forward allowed traffic
5. delay or reject excess

This prevents sudden overload.

## Example
Two tenants share the same inference cluster:

- Tenant A (premium)
- Tenant B (best-effort)

Traffic shaping:
- A gets guaranteed rate
- B is throttled during peaks

Premium SLAs remain stable even during contention.

## Relationship to scaling
Traffic shaping complements scaling:

- **Shaping** → control demand
- **Scaling** → increase supply

If scaling is slow (GPU provisioning latency), shaping protects the system until capacity catches up.

Both are necessary for stable GPU platforms.

## Role in the control plane
The control plane may:

- configure rate limits per tenant
- assign priorities by tier
- dynamically adjust thresholds
- shift traffic between pools
- protect critical workloads
- enforce fairness

Policies are often applied via Gateway API or service mesh layers.

## Traffic shaping vs load balancing
- **Load balancing** → distribute traffic evenly
- **Traffic shaping** → control volume and priority

Balancing spreads work; shaping regulates it.

## Mental model
Traffic shaping is the “traffic light and speed limit” system that prevents too many cars from flooding the road at once.

## Related terms
- [Gateway API](./gateway-api.md)
- [Load Balancing](./load-balancing.md)
- [Inference API](./inference-api.md)
- [SLO](./slo.md)
- [Utilization](./utilization.md)
- [Horizontal Pod Autoscaler](./horizontal-pod-autoscaler.md)
