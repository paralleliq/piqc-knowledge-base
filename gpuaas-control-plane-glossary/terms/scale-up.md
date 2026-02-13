# Scale Up

## Definition
Scale up is the process of increasing compute capacity by adding more resources such as pods, replicas, or nodes to meet rising demand.

It is the opposite of scale down.

In GPUaaS platforms, scale up answers:
“How do we add more GPUs quickly when demand increases?”

## Why it matters in GPUaaS
GPU workloads often arrive in bursts:

- large training jobs
- sudden inference traffic spikes
- new tenant onboarding
- batch processing waves

If the platform cannot add capacity fast enough:
- jobs remain pending
- queues grow
- latency increases
- SLAs are missed
- idle ranks appear

Scale up ensures the system can respond elastically to demand.

## Responsibilities
Scale-up mechanisms typically:

- detect insufficient capacity
- provision new nodes
- increase pod replicas
- maintain availability targets
- protect high-priority workloads
- restore buffers or warm pools

It focuses on ensuring enough supply exists.

## Typical behavior
1. demand increases (pending pods or high utilization)
2. control plane or autoscaler detects shortage
3. new nodes are requested
4. nodes become Ready
5. scheduler places workloads
6. service performance stabilizes

Scaling up happens automatically and continuously.

## Example
Cluster:
- 20 GPUs available
- training job requests 16 GPUs
- other jobs already using 10 GPUs

Shortage detected:
- autoscaler provisions 10 new GPUs
- nodes join
- job schedules successfully

Without scale up, job would wait.

## Common triggers

### Pending workloads
Pods cannot be scheduled

### High utilization
GPU usage above threshold

### Queue depth
Backlog exceeds target

### SLA risk
Latency or startup times degrade

### Proactive forecast
Expected traffic spike

These signals indicate more capacity is needed.

## Scale up vs provisioning
- **Scale up** → decision to increase capacity
- **Provisioning** → actual creation of nodes

Scale up triggers provisioning actions.

## Reactive vs proactive
### Reactive
Add capacity after demand appears  
- simpler  
- slower startup  

### Proactive
Add capacity before demand  
- faster startup  
- higher baseline cost  

Many GPU platforms use both.

## Risks
Aggressive scale up can cause:

- unnecessary cost
- over-provisioning
- idle nodes after spikes
- thrashing

Control planes often combine:
- limits
- buffers
- cooldown periods

to maintain stability.

## Role in the control plane
The control plane may:

- prioritize which workloads trigger scale up
- allocate capacity by tier
- decide GPU shapes
- maintain warm pools
- enforce cost limits
- coordinate with admission gating

It determines when and how to expand.

## Mental model
Scale up is the “add more seats” action — increasing supply so workloads don’t have to wait.

## Related terms
- [Autoscaler](./autoscaler.md)
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Proactive Scaling](./proactive-scaling.md)
- [Capacity Buffer](./capacity-buffer.md)
- [Queue Depth](./queue-depth.md)
- [Scale Down](./scale-down.md)

