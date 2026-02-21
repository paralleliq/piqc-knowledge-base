# Silent Data Corruption (SDC) in GPUaaS Fleets

Silent Data Corruption (SDC) occurs when computation produces incorrect results **without crashing or surfacing obvious errors**.

In GPU-as-a-Service (GPUaaS) environments, SDC is particularly dangerous because:

- Workloads are multi-tenant  
- Training and inference jobs can run for long durations  
- Distributed workloads amplify corruption across ranks  
- Customers may not detect issues until much later  
- Financial and reputational impact can be significant  

Unlike visible failures (OOM, driver crash, node failure), SDC can silently degrade model quality, invalidate training runs, or corrupt inference outputs without immediate alarms.

---

## Why GPUaaS Providers Should Care

For GPUaaS operators, SDC is not just a hardware issue — it is a **fleet governance issue**.

Unchecked SDC can lead to:

- Incorrect training checkpoints  
- Subtle inference output drift  
- Failed reproducibility  
- Tenant dissatisfaction  
- SLA violations  
- Loss of trust in the platform  

As fleets scale, the probability of rare hardware anomalies increases. What is statistically negligible on a single GPU becomes material at fleet scale.

---

## SDC Is a Fleet Lifecycle Problem

SDC risk is influenced by more than runtime conditions. It is shaped across the entire GPU lifecycle:

1. Hardware quality and early-life failures  
2. Thermal and power stability  
3. Driver and firmware alignment  
4. Distributed communication integrity  
5. Ongoing fleet health monitoring  
6. Proper retirement and quarantine procedures  

Tightening GPU onboarding and offboarding processes significantly reduces long-term corruption risk across the fleet.

---

## Categories of SDC Risk

### 1. Hardware-Level Risks
- Uncorrectable ECC errors  
- Growing retired memory pages  
- Repeated Xid events  
- Thermal instability  
- Power irregularities  

### 2. Distributed System Risks
- AllReduce divergence  
- Rank desynchronization  
- Collective communication instability  
- NCCL anomalies  

### 3. Operational Risks
- Mixing unstable GPUs into reserved tiers  
- Lack of burn-in validation  
- Inadequate retirement processes  
- Missing telemetry baselines  

---

## Prevention Strategy Overview

An effective SDC mitigation strategy includes:

### ✅ Structured GPU Onboarding
- ECC validation  
- Sustained burn-in  
- Memory stress tests  
- Baseline performance fingerprinting  

### ✅ Continuous Fleet Monitoring
- ECC error tracking  
- Retired page growth  
- Thermal and power drift  
- MFU anomalies  

### ✅ Intelligent Tiering
- Restrict unstable GPUs to best-effort tiers  
- Protect reserved tiers from high-risk hardware  
- Prevent silent degradation in premium workloads  

### ✅ Controlled Retirement
- Quarantine GPUs with repeated instability  
- Remove degraded hardware before corruption spreads  
- Maintain fleet hygiene  

---

## Detection vs. Prevention

| Detection | Prevention |
|------------|------------|
| Monitoring ECC and Xid logs | Burn-in before production |
| Identifying divergence in training | Tier-based isolation |
| Observing SLA anomalies | Thermal and power baselining |
| Replay validation | Structured retirement policy |

Detection reduces impact.  Prevention reduces probability.  Both are required in GPUaaS environments.

---

## Strategic Perspective

At small scale, SDC events appear rare.

At fleet scale, rare events become predictable operational risks.

A mature GPUaaS platform treats SDC not as a hardware accident, but as a governance and lifecycle management concern.

Silent corruption is not just a GPU problem.  It is a control plane responsibility.

---

## Related Documents

📂 [`detection-checklist/`](./detection-checklist.md)

📂 [`distributed-training-considerations/`](./distributed-training-considerations.md)

📂 [`onboarding-and-retirement/`](./onboarding-and-retirement.md)

📂 [`operational-playbook/`](./operational-playbook.md)

---

Maintaining trust in shared GPU infrastructure requires more than uptime.  It requires confidence that results are correct.

