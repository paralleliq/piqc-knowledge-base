# Horizontal Pod Autoscaler (HPA)

## Definition
Horizontal Pod Autoscaler (HPA) is a Kubernetes component that automatically adjusts the number of pod replicas for a workload based on observed metrics such as CPU, memory, or custom signals.

It scales applications horizontally by increasing or decreasing the number of running pods.

In GPUaaS platforms, HPA primarily manages *application-level scaling*, not node-level capacity.

It answers:
“How many replicas of this service should be running?”

## Why it matters in GPUaaS
Many GPU-backed workloads — especially inference services — experience variable traffic:

- request spikes
- time-of-day demand changes
- bursty workloads

Running a fixed number of replicas either:
- wastes GPUs during low demand, or
- overloads during peaks

HPA allows services to dynamically scale replicas to match demand, improving both performance and cost efficiency.

## Responsibilities
HPA typically:

- monitors workload metrics
- compares against target thresholds
- increases replica count when demand rises
- decreases replica count when demand falls
- maintains min/max bounds

It focuses on workload concurrency, not provisioning nodes.

## Typical behavior
1. traffic increases
2. CPU/GPU utilization rises
3. HPA scales replicas up
4. scheduler places new pods
5. autoscaler may provision nodes if needed

When traffic drops:
- replicas scale down
- unused nodes may be consolidated

HPA and node autoscalers often work together.

## Common metrics
HPA can scale based on:

- CPU utilization
- memory usage
- request rate (RPS)
- queue length
- custom metrics (e.g., GPU utilization or inference latency)

GPU inference platforms often use custom metrics rather than CPU.

## Example
Inference service:

- target: 60% utilization per pod
- traffic doubles

HPA:
- increases replicas from 4 → 8
- requests more GPUs
- node autoscaler provisions capacity if required

This maintains latency targets.

## HPA vs node autoscaling
- **HPA** → scales number of pods (demand side)
- **Autoscaler/Karpenter** → scales number of nodes (supply side)

Both are needed:
pods scale first → nodes follow.

## Limitations
HPA does not:

- manage quotas or fairness
- provision nodes directly
- understand business priorities

It only adjusts replica counts.

For training workloads that need fixed multi-GPU allocations, HPA is usually not used.

## Mental model
HPA is the “replica dial” that turns services up or down based on load, while node autoscalers supply the hardware underneath.

## Related terms
- [Autoscaler](./autoscaler.md)
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Gateway API](./gateway-api.md)
- [GPU Utilization](./gpu-utilization.md)
