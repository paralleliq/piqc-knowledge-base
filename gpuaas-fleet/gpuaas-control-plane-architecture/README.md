# The GPU Platform Control Plane  
*A workflow-first architecture for selling GPUs as a reliable product*

---

## Why This Exists

Modern GPU platforms treat Kubernetes or Slurm as the “control plane.”

This is a category error.  What’s missing is a **business-rules control plane** that owns:

- tenant identity and lifecycle  
- resource entitlements and envelopes  
- admission control  
- isolation and GPU sharing policy  
- SLA tiers and priority semantics  
- placement rules  
- runtime enforcement and degradation  

Without this layer, GPU platforms are best-effort science projects — not products.

This repository defines the **minimal architecture** required to sell GPUs as a reliable, multi-tenant service.

---

## The Core Thesis

A real GPU platform is not a scheduler.

It is a **workflow engine + policy engine + state machine** that mediates all product-affecting user actions, emits constrained workloads to the orchestrator, and continuously enforces SLAs and tenant envelopes using runtime feedback from GPUs.

That missing layer is the GPU platform operating system.

---

## The Four Swim Lanes

The diagram below shows the minimal control-plane architecture.

All important decisions happen *before* Kubernetes or Slurm sees a workload.

---

### Lane 1 — Tenant / API Client  
*Product-level user actions*

These are the actions customers believe they are performing:

- Tenant signup  
- Tenant deletion  
- Submit workload  
- Create service  
- Deploy model  
- Scale service  
- Change batch size  
- Request GPU sharing  
- Change placement  
- Change priority  
- Request quota increase  

These actions must never talk directly to Kubernetes or Slurm.

---

### Lane 2 — Business-Rules Control Plane (Rubicon OS)  
*Product semantics, policies, and workflows*

This lane defines the GPU platform operating system.

**Tenant & Entitlement Workflows**
- Tenant creation / suspension / deletion  
- Assign SLA tier  
- Create / update tenant envelope  
- Apply burst rules  

**Admission Control Workflows**
- Job submission admission  
- Service creation admission  
- Model deployment admission  
- Scaling request admission  
- Batch size change admission  
- GPU sharing request admission  
- Placement change admission  
- Priority change admission  

**Placement & Isolation Workflows**
- Node pool selection  
- Tenant affinity / anti-affinity  
- GPU sharing eligibility  
- Co-tenancy compatibility  
- Memory headroom checks  

**SLA & Priority Workflows**
- SLA tier enforcement  
- Priority class assignment  
- Preemption rules  
- Degradation ordering  

**Runtime Enforcement Workflows**
- SLA violation detection  
- Memory pressure detection  
- KV-cache growth detection  
- Throughput degradation detection  

**Degradation & Recovery Workflows**
- Tenant throttling  
- Batch size reduction  
- Admission stop  
- Workload eviction  
- Graceful shutdown  
- SLA credit issuance  

This lane is the control plane.  Everything else is execution machinery.

---

### Lane 3 — Orchestrator (Kubernetes / Slurm)  
*Execution dispatcher, not a policy engine*

- Queue jobs  
- Bind jobs to nodes  
- Launch containers  
- Restart failed jobs  
- Schedule within pre-computed constraints  

The orchestrator executes decisions already made upstream.  It does not define product semantics.

---

### Lane 4 — Execution Layer (GPU Fleet)  
*Where physics happens*

- GPUs  
- Nodes  
- ROCm / CUDA  
- Drivers  
- KV cache  
- Memory  
- PCIe / NVLink  
- Network fabric  

This lane produces telemetry, not policy.

---

## Closed-Loop Control

The defining feature of a real GPU platform OS is a feedback loop:

- Runtime telemetry flows from Lane 4 → Lane 2  
- The control plane triggers enforcement workflows  
- New constraints flow from Lane 2 → Lane 3  

This makes the system a **closed-loop control plane**, not a one-shot scheduler.

---

## Why This Layer Is Missing Today

Most GPU platforms fail to implement this layer because:

- Kubernetes cannot enforce tenant envelopes  
- Schedulers cannot reason about SLAs  
- GPUs have weak isolation semantics  
- Admission control is mostly absent  
- Degradation is accidental, not deterministic  

This is why GPU clouds feel unreliable and unfair under load.

---

## Control Plane: Execution, Observability, and Business Rules

![GPU Platform Control Plane Swim Lane](gpuaasbpm.jpg)

---
## Full-Stack Heterogeneous Performance & Control Plane View

| Lane | Layer Name | Primary Responsibility | Typical Tooling | Answers What Question? |
|------|------------|------------------------|------------------|------------------------|
| 1 | Governance & Intent | Policy, SLA, compliance, cost governance | OPA, Kyverno, Kubecost, Datadog, Grafana, Audit logging systems | What is allowed? What is promised? What is billable? |
| 2 | Control Plane & Workflow | Admission control, policy enforcement, workflow orchestration | Kubernetes control plane, Slurm controller, LSF, Kueue, Argo, Kubeflow, Custom CRDs, n8n | Should this workload run? Under what constraints? |
| 3 | Orchestration & Placement | Resource binding, topology-aware scheduling, isolation | Kubernetes scheduler, Slurm scheduler, Karpenter, Node affinity/taints, MIG configuration, NCCL topology detection, Ray placement groups | Where should it run? On which node / GPU / topology domain? |
| 4 | Runtime & Execution | Actual workload execution, kernel launches, collectives | PyTorch, TensorFlow, vLLM, Triton, CUDA runtime, NCCL, cuBLAS, cuDNN, MPI, OpenMP, jemalloc | How is the workload structured and executed? |
| 5 | Microarchitecture & Heterogeneous Performance Attribution | Stall analysis, cache behavior, warp efficiency, interconnect bottlenecks | perf, eBPF, VTune, LIKWID, Nsight Systems, Nsight Compute, CUPTI, Flame graphs, NCCL tests, ibstat | Why is it slow? Which domain is limiting (CPU, GPU, memory, fabric)? |
| 6 | Performance & Reliability Envelope (Physical Platform & RAS) | Power, thermal limits, clock behavior, ECC, hardware health, degradation | nvidia-smi, DCGM, BMC/IPMI, Redfish, lm-sensors, kernel logs, ECC counters, Xid logs | Is performance sustainable? Is hardware stable and safe for placement? |

---

## What This Is (and Is Not)

This repository is:

- a reference architecture  
- a workflow taxonomy  
- a product-OS definition  
- a control-plane design blueprint  

This repository is not:

- a Kubernetes tuning guide  
- a scheduler configuration manual  
- a hardware bring-up checklist  

---

## Who This Is For

- GPU cloud providers  
- AI platform teams  
- Infrastructure founders  
- CTOs building multi-tenant GPU platforms  
- Anyone trying to sell GPUs as a product

---

## License

This content is published as vendor-neutral architecture guidance.

Use it freely.  Build on it.  Argue with it.

---

## About ParallelIQ

ParallelIQ builds control-plane tooling and open specifications for GPU-heavy AI platforms.

Our work focuses on closing the **AI Execution Gap** between how models are supposed to run and how they actually run in production.

Learn more: https://paralleliq.ai


