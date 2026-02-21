# Load Balancing

## Definition
Load balancing is the process of distributing incoming requests or workloads across multiple replicas, nodes, or GPUs to ensure efficient utilization, high availability, and consistent performance.

It prevents any single instance from becoming overloaded while others remain idle.

In GPUaaS platforms, load balancing determines:
“Which replica or GPU should handle this request?”

## Why it matters in GPUaaS
Inference and service workloads often receive uneven or bursty traffic:

- spikes in requests
- hot models
- uneven tenant usage
- variable latency

Without load balancing:
- some GPUs saturate
- others sit idle
- latency increases
- errors rise
- SLAs are missed

Load balancing improves both performance and hardware efficiency.

## Responsibilities
Load balancing systems typically:

- distribute traffic evenly across replicas
- route around failures
- perform health checks
- support scaling up/down
- maintain availability
- reduce hotspots
- optionally apply traffic policies (weights, canaries)

It focuses on traffic distribution, not scheduling or provisioning.

## Typical behavior
1. client sends request to endpoint
2. gateway or service receives request
3. balancer selects healthy backend
4. request forwarded
5. response returned

Selection may use algorithms such as round-robin or least-loaded.

## Common algorithms

### Round robin
Evenly rotates requests across replicas  
Simple and predictable.

### Least connections / least loaded
Prefers less busy replicas  
Better for variable workloads.

### Weighted
Routes based on capacity or priority  
Useful for mixed GPU shapes.

### Sticky sessions
Keeps requests on same backend  
Useful for caching or stateful services.

Different workloads benefit from different strategies.

## Example
Model served by 4 GPU replicas.

Without load balancing:
- 1 replica receives most traffic → high latency
- others idle

With load balancing:
- traffic distributed evenly
- latency drops
- utilization improves

## Role in the control plane
The control plane may:

- configure routing rules
- adjust weights during rollouts
- scale replicas (via HPA)
- remove unhealthy instances
- shift traffic between pools or tiers

Load balancing is often implemented through Gateway API or service mesh layers.

## Load balancing vs scheduling
- **Scheduling** → where pods run
- **Load balancing** → where requests go

Scheduling decides placement; load balancing decides traffic.

Both are required for efficient GPU use.

## Mental model
Load balancing is the “traffic distributor” that spreads work evenly so all GPUs contribute instead of a few doing all the work.

## Related terms
- [Gateway API](./gateway-api.md)
- [Service](./service.md)
- [Horizontal Pod Autoscaler](./horizontal-pod-autoscaler.md)
- [GPU Utilization](./gpu-utilization.md)
- [Inference API](./inference-api.md)
