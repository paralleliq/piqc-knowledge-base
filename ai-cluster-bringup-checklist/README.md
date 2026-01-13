# PIQC AI Cluster Bringup Checklist

## About This Checklist

This checklist provides a **structured, end-to-end framework** for assessing whether an AI GPU cluster is ready to support **real production workloads**.

It is designed to surface gaps across the full AI control plane — from hardware and networking to orchestration, runtime, observability, and governance — before costly misconfigurations make it into production.

This checklist is:

- **Vendor-neutral**  
- **Applicable to on-prem, colocation, and GPU cloud environments**  
- **Designed for self-assessment, architecture reviews, and Phase-0 bring-up**

This is **not** an implementation guide. Unchecked or unclear items indicate areas that typically require **deeper architectural design or cross-team alignment** before the cluster can be considered production-ready.


# Bare-Metal AI Cluster Bring-Up Checklist

**From Power-On to Production Operations**

## 0. Physical & Environmental Readiness (Often Skipped, Always Painful) 

**Rack & Facility**

- [ ] Rack layout validated for GPU density and airflow
- [ ] Power budget confirmed per rack (peak, not average)
- [ ] Redundant power feeds (A/B) tested
- [ ] Cooling model validated under full GPU load
- [ ] Environmental sensors deployed (temp, humidity)

**Cabling**

- [ ] NIC cabling matches intended topology (leaf-spine, fat-tree, etc.)
- [ ] OOB network physically isolated
- [ ] Cable labeling consistent and documented
- [ ] ⚠ Many failures blamed on "software” start here.

## 1. Out-of-Band (OOB) & Hardware Control Plane 

**BMC / OOB Access**

- [ ] BMC/IPMI/Redfish reachable for every node
- [ ] Default credentials rotated
- [ ] RBAC applied to OOB access
- [ ] Firmware versions inventoried

**Power & Recovery**

- [ ] PDUs integrated and remotely controllable
- [ ] Power cycling tested at node and rack level
- [ ] Remote console access validated

**Hardware Inventory**

- [ ] CPU, RAM, GPU, NICs auto-discovered
- [ ] Serial numbers and asset IDs recorded
- [ ] Firmware / BIOS baseline defined
- [ ] 🔑 This is the *real* "Day-0 control plane”.

## 2. BIOS, Firmware & Low-Level Configuration 

**BIOS / Firmware**

- [ ] GPU-friendly BIOS settings applied (IOMMU, SR-IOV if applicable)
- [ ] NUMA configuration validated
- [ ] Power management settings aligned with performance goals
- [ ] Secure boot policy defined (on/off)

**NIC & GPU Firmware**

- [ ] NIC firmware versions pinned
- [ ] GPU firmware compatibility verified
- [ ] Upgrade / rollback process documented

## 3. OS Bring-Up & Host Baseline 

**OS Provisioning**

- [ ] Automated PXE / image-based provisioning
- [ ] OS version pinned and documented
- [ ] Kernel parameters tuned for GPU workloads
- [ ] Time sync (NTP/PTP) configured

**Security Baseline**

- [ ] SSH access controlled
- [ ] Host firewall rules applied
- [ ] Audit logging enabled
- [ ] CIS or internal hardening baseline applied

**Host Validation**

- [ ] GPU visible to OS
- [ ] NIC throughput verified
- [ ] Disk I/O baseline tested

## 4. Networking (Where Most Clusters Break) 

**Management Plane**

- [ ] Dedicated management network
- [ ] DNS, NTP, certificate services reachable
- [ ] Routing & firewall rules validated

**Data Plane**

- [ ] Fabric selected (Ethernet / RoCE / IB)
- [ ] MTU & ECN settings consistent
- [ ] Bandwidth and latency validated
- [ ] Failure scenarios tested (link down, switch down)

**Segmentation**

- [ ] Management vs data traffic separated
- [ ] Tenant isolation model defined (VLAN/VXLAN/etc.)

## 5. GPU Runtime & Driver Stack 

**GPU Drivers**

- [ ] Driver version pinned
- [ ] Compatibility matrix validated (GPU ↔ driver ↔ OS)
- [ ] Upgrade strategy defined

**Runtime**

- [ ] CUDA / ROCm installed and validated
- [ ] Container runtime GPU integration tested
- [ ] GPU health and telemetry available

**Sanity Checks**

- [ ] Simple GPU workloads run successfully
- [ ] Multi-GPU visibility validated
- [ ] Error handling tested (GPU reset, ECC errors)

## 6. Orchestration & Cluster Control Plane 

**Orchestrator Selection**

- [ ] Kubernetes / Slurm / Hybrid decision made
- [ ] Decision documented with tradeoffs

**Control Plane Bring-Up**

- [ ] HA control plane configured
- [ ] Scheduler configured for GPUs
- [ ] Node labeling & topology awareness applied

**GPU Scheduling**

- [ ] Allocation model defined (exclusive vs shared)
- [ ] Preemption behavior defined
- [ ] Priority & fairness policies set
- [ ] 🔥 This is where "we’ll figure it out later” becomes expensive.

## 7. Workload Admission & Governance 

**Admission Control**

- [ ] Who can submit workloads?
- [ ] How are GPUs requested?
- [ ] Validation of requests enforced

**Quotas & Fairness**

- [ ] Per-team / per-tenant quotas
- [ ] Burst behavior defined
- [ ] Starvation prevention mechanisms

**Lifecycle**

- [ ] Job suspension / resumption
- [ ] Cleanup policies
- [ ] Resource leak prevention

## 8. Model & Artifact Lifecycle 

**Registries**

- [ ] Container registry access controlled
- [ ] Model registry defined
- [ ] Artifact provenance tracked

**Promotion Flow**

- [ ] Dev → staging → prod path defined
- [ ] Approval gates documented
- [ ] Rollback strategy defined

**Deployment Patterns**

- [ ] Have canary deployment strategies been defined?
- [ ] Have shadow deployments been considered where applicable?
- [ ] Is a rollback strategy documented?

## 9. Observability & Operational Semantics 

**Metrics**

- [ ] GPU utilization, memory, errors
- [ ] Node health metrics
- [ ] Workload latency & throughput
- [ ] Queue depth & scheduling delays

**Logs & Traces**

- [ ] Centralized logging
- [ ] Request-to-GPU traceability
- [ ] Correlation across layers

**SLOs**

- [ ] Latency targets (P95/P99)
- [ ] Availability targets
- [ ] Alert thresholds defined
- [ ] Operators must answer: *Is this a GPU issue, a model issue, or a traffic issue?*

## 10. Security & Compliance 

**Identity & Access**

- [ ] SSO integrated
- [ ] RBAC defined
- [ ] Least-privilege enforced

**Secrets**

- [ ] KMS / Vault integrated
- [ ] No secrets on disk or in images

**Isolation**

- [ ] Tenant isolation guarantees defined
- [ ] Network isolation enforced
- [ ] Data isolation validated

**Compliance**

- [ ] SOC2 / HIPAA / internal controls mapped
- [ ] Audit logs retained
- [ ] Access reviews possible

## 11. Lifecycle Operations (Day-2 Reality) 

**Upgrades**

- [ ] OS upgrade strategy
- [ ] Driver / runtime upgrade path
- [ ] Rolling vs blue-green defined

**Failure Handling**

- [ ] Node failure recovery
- [ ] GPU fault handling
- [ ] Network failure response

**Capacity**

- [ ] Headroom defined
- [ ] Scale-out process documented
- [ ] Decommissioning process defined

## 12. Handoff & Ownership 

**Runbooks**

- [ ] Bring-up runbooks
- [ ] Incident playbooks
- [ ] Upgrade playbooks

**Ownership**

- [ ] Who owns what?
- [ ] Escalation paths defined
- [ ] Customer vs provider responsibilities clear

## How to Use This Checklist

- If you can confidently check **80–90%** of the items, your cluster is likely ready for **production operations**.
- If **30–60%** of the items are unclear or unchecked, you likely need a **Phase 0 architecture review**.
- If many items are “we’ll figure this out later,” expect **costly rework and operational risk**.

---

## What This Checklist Is For

This checklist is designed to help teams bring up AI infrastructure in a **structured, cross-disciplinary way**.

AI clusters are not just compute. They require coordination across:

- **Hardware and networking**
- **Orchestration and scheduling**
- **Model runtime and serving**
- **Observability, security, and compliance**

This checklist provides a **single, end-to-end view** of what needs to be in place before production workloads can run reliably.

---

## What You Get From Using It

By working through this checklist, teams can:

- **Identify gaps early**  
  Catch missing configuration, capacity, or ownership issues before they become outages.

- **Align teams**  
  Provide a shared reference for platform, ML, SRE, and security teams during cluster bring-up.

- **Make the control plane explicit**  
  Clarify how GPUs, networking, runtimes, scaling, and monitoring are expected to work together.

- **Reduce bring-up time**  
  Avoid weeks of trial-and-error by following a structured, battle-tested checklist.

---

## How Teams Typically Use This

This checklist can be used in several ways:

- **As a readiness diagnostic**  
  To assess whether a cluster is ready for real AI workloads.

- **As a design review tool**  
  To validate architecture and control-plane decisions before deployment.

- **As an operational baseline**  
  To establish what “done” looks like for an AI platform.

- **As an open reference**  
  To share best practices across teams and organizations.


## Contributions

This checklist reflects real-world experience operating bare-metal AI
clusters.

Contributions are welcome:

    - Additional failure modes
    - Missing readiness checks
    - Clarifications for different environments

Please keep additions vendor-neutral and experience-driven.

Disclaimer:

This checklist is provided for planning and assessment purposes only and
does not replace professional architectural review.

## 🔗 Related Checklists & Guides

-  **GenAI Model Deployment Checklist**  
  [`/CHECKLIST.md`](../CHECKLIST.md)

-  **AI Infrastructure Best Practices**  
  [`ai-infrastructure-best-practices-and-playbooks/`](../ai-infrastructure-best-practices-and-playbooks/)

-  **AI Infrastructure Audit & Readiness (42-Point)**  
  [`ai-infrastructure-audit-and-readiness-checklist/`](../ai-infrastructure-audit-and-readiness-checklist/)

-  **AI Governance & Compliance Checklist**  
  [`ai-governance-and-compliance-checklist/`](../ai-governance-and-compliance-checklist/)

-  **AI Governance & Compliance Checklist**  
  [`ai-governance-and-compliance-checklist/`](../ai-governance-and-compliance-checklist/)

-  **Model Deployment Quality Checklist**  
  [`ai-model-deployment-quality-checklist/`](../ai-model-deployment-quality-checklist/)

-  **LLM Inference Production Readiness (Kubernetes + vLLM)**  
  [`llm-inference-production-readiness-checklist/`](../llm-inference-production-readiness-checklist/)

-  **vLLM Runtime Metrics & Observability Guide**  
  [`vllm-runtime-metrics-and-observability-guide/`](../vllm-runtime-metrics-and-observability-guide/)
