```markdown
# Execution Layer

## Definition
The execution layer is the part of the platform that directly runs workloads and enforces resource decisions. It includes the scheduler, autoscaler, networking, and runtime components that place pods, provision nodes, and execute containers on hardware.

It is responsible for carrying out the actions requested by the orchestration layer.

If the governance layer decides and the orchestration layer applies, the execution layer runs.

## Why it matters in GPUaaS
This layer determines the actual behavior of the cluster:
- which workloads start
- where they run
- when nodes are created or removed
- how traffic is routed
- how resources are consumed

GPU workloads are sensitive to startup latency, placement, and capacity timing. The execution layer’s behavior directly impacts utilization, cost, and reliability.

Poor coordination here leads to:
- cold starts
- idle GPUs
- fragmented capacity
- failed distributed jobs

## Responsibilities
- schedule pods onto nodes
- provision and deprovision nodes
- enforce quotas, priorities, and preemption
- manage networking and service routing
- expose runtime metrics and health signals
- run containers and GPU processes

## Typical components
Examples include:
- Kubernetes scheduler
- Kueue (admission and queuing)
- Karpenter or other autoscalers
- Gateway and Inference APIs
- device plugins and runtimes

These systems enforce the state that higher layers declare.

## What it does not do
The execution layer does not understand business intent, tenant policies, or platform rules. It only enforces the configuration it is given.

It answers:
“What can run right now?”

Not:
“What should run?”

## Example
After the orchestration layer provisions nodes and admits a workload, the execution layer:
1. schedules pods,
2. binds them to nodes,
3. allocates GPUs,
4. runs the containers.

## Related terms
- [Control Plane](./control-plane.md)
- [Governance Layer](./governance-layer.md)
- [Orchestration Layer](./orchestration-layer.md)
- [Admission Control](./admission-control.md)
- [Provisioning](./provisioning.md)
- [Device Plugin](./device-plugin.md)
```

