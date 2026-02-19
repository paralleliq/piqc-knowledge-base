# Operational Playbook  
_Silent Data Corruption (SDC) & GPU Fleet Stability_  
_For GPUaaS Providers_

This playbook provides structured operational response procedures for:

- Suspected Silent Data Corruption (SDC)
- Distributed training instability
- GPU degradation events
- Fleet-wide anomaly detection

The goal is to minimize impact, protect tenants, and preserve trust.

---

# 1. Guiding Principles

1. Protect correctness over utilization.
2. Isolate risk quickly.
3. Avoid silent recycling of unstable hardware.
4. Communicate clearly when tenant impact is possible.
5. Feed detection signals into governance policies.

SDC response is both technical and reputational.

---

# 2. SDC Suspicion Workflow

## Trigger Conditions

Initiate investigation if you observe:

- Sudden MFU drop without load change
- Repeated ECC growth
- Uncorrectable ECC error
- Repeated Xid events
- Divergent training checkpoints
- Inference replicas producing inconsistent outputs
- SLA degradation without traffic spike

---

## Step 1: Contain

- Mark GPU as "suspect"
- Prevent new workload placement
- Drain active workloads if high risk
- Freeze reclaim actions involving the GPU

Never allow suspect GPUs into reserved tiers.

---

## Step 2: Capture Diagnostics

Collect:

```bash
nvidia-smi -q
nvidia-smi -q -d ECC
dmesg | grep -i xid
journalctl -k | grep -i nvrm


Capture:

Current workload metadata

MFU readings

Power and thermal metrics

Collective logs (if distributed training)

Preserve logs before restarting anything.

Step 3: Validate

Run:

Short stress test

Memory validation

Deterministic test workload

Gradient consistency check (if training)

If instability reproduces → escalate to quarantine.

If stable → continue monitoring with elevated watch.

3. Quarantine Procedure

When instability confirmed:

Remove GPU from production pool

Downgrade tier to best-effort (if partial confidence)

Or fully remove from scheduler

Update fleet health score

Document incident

Quarantine prevents silent propagation.

4. Distributed Training Incident Playbook

If distributed training divergence detected:

Identify rank with anomaly

Map rank → physical GPU

Check health score

Compare MFU and power draw across ranks

Drain suspect GPU

Never assume training bug before ruling out hardware instability.

5. Inference Instability Playbook

If inference drift or SLA instability observed:

Compare replica outputs

Identify node-level anomalies

Check for thermal throttling

Check for recent reclaim/preemption events

Validate autoscaling state

Escalate if output inconsistency persists.

6. Fleet-Level Anomaly Response

If pattern detected across cluster:

Analyze hardware batch cohort

Check shared firmware or driver changes

Compare burn-in cohort history

Pause onboarding of similar GPUs

Audit recent changes to placement policies

Cluster-wide anomalies may signal systemic issues.

7. Communication Protocol

If tenant impact likely:

Notify affected tenant platform lead

Share high-level findings

Avoid speculative root cause statements

Provide remediation timeline

Transparency builds long-term trust.

8. Policy Feedback Loop

Every SDC incident should update:

Placement restrictions

Tier eligibility rules

Health scoring weights

Onboarding validation thresholds

Reclaim protections

Operational learning must influence governance.

9. Post-Incident Review Template

Document:

GPU ID

Cluster

Tenant impact

Detection trigger

Root cause

Time to containment

Policy updates implemented

SDC is rare per device — but predictable at scale.
Learning compounds operational maturity.

10. Control Plane Integration

A mature GPUaaS control plane should:

Automatically restrict suspect GPUs

Integrate health scoring into placement

Prevent unstable GPUs from entering reserved tiers

Trigger quarantine workflows programmatically

Track incident history per GPU

Operational discipline must be systematic — not manual.

Summary

SDC management requires:

Early detection

Rapid containment

Structured validation

Controlled quarantine

Governance feedback

Fleet reliability is not just uptime.
It is correctness, stability, and trust at scale.

