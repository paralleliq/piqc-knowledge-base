# Vertical Pod Autoscaler (VPA)

## Definition
Vertical Pod Autoscaler (VPA) is a Kubernetes component that automatically adjusts the resource requests and limits of individual pods based on observed usage.

It scales workloads vertically by changing how much CPU, memory, or other resources each pod requests.

In GPUaaS platforms, VPA answers:
“How big should each pod be?”

## Why it matters in GPUaaS
Workloads often request the wrong size:

- over-request → wasted GPUs or memory
- under-request → OOMs, throttling, instability

Mis-sizing causes:

- fragmentation
- poor bin packing
- low utilization
- scheduling failures
- unnecessary cost

VPA helps right-size workloads to match actual usage.

## Responsibilities
VPA typically:

- observe historical resource usage
- recommend optimal requests/limits
- automatically update pod specs (optional)
- reduce over-provisioning
- improve packing efficiency
- stabilize workloads

It optimizes per-pod sizing, not cluster capacity.

## Typical behavior
1. workload runs
2. VPA collects usage metrics
3. calculates recommended resources
4. updates requests/limits
5. pods restart with new sizing (depending on mode)

Over time, pods converge to appropriate sizes.

## Modes

### Off
Only provides recommendations

### Initial
Sets resources only at pod creation

### Auto
Actively updates and restarts pods

GPU platforms often prefer recommendation or initial modes for stability.

## Example
Inference pod requests:

- 2 CPUs
- 16GB RAM
- 1 GPU

Actual usage:
- 0.5 CPU
- 6GB RAM

VPA recommends:
- 1 CPU
- 8GB RAM

Smaller footprint allows:
- better bin packing
- more replicas per node
- lower cost

## GPU considerations
VPA usually:

- does not change GPU count automatically
- focuses on CPU/memory sizing

GPU scaling is typically handled by:
- HPA (replicas)
- node autoscalers (capacity)

Thus VPA complements but does not replace them.

## VPA vs HPA vs node autoscaling
- **VPA** → change pod size
- **HPA** → change pod count
- **Autoscaler/Karpenter** → change node count

Together they control:
size × count × capacity

Each operates at a different layer.

## Role in the control plane
The control plane may:

- enable VPA recommendations
- use sizing data for planning
- enforce right-sizing policies
- prevent waste
- integrate into cost optimization workflows

It improves efficiency automatically over time.

## Mental model
VPA is the “right-size tool” that ensures each pod asks for only what it truly needs.

## Related terms
- [Horizontal Pod Autoscaler](./horizontal-pod-autoscaler.md)
- [Autoscaler](./autoscaler.md)
- [Utilization](./utilization.md)
- [Bin Packing](./bin-packing.md)
- [Cost Optimization](./cost-optimization.md)
- [Provisioning](./provisioning.md)
