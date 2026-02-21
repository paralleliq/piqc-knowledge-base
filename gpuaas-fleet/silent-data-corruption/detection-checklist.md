# Silent Data Corruption (SDC) Detection Checklist
_For GPUaaS Providers_

Silent Data Corruption (SDC) occurs when GPUs produce incorrect results without crashing or raising explicit errors.

In GPU-as-a-Service (GPUaaS) environments, SDC is particularly dangerous because:

- Workloads are multi-tenant  
- Training jobs run for long durations  
- Distributed systems amplify errors  
- Customers may detect issues too late  
- Trust in the platform can be damaged  

This checklist outlines practical detection mechanisms for fleet-scale GPU operations.

---

## 1. Hardware-Level Detection

### 1.1 ECC Monitoring

Monitor continuously:

- Correctable ECC errors  
- Uncorrectable ECC errors  
- Retired memory pages  
- Pending page retirements  

Commands:

```bash
nvidia-smi -q -d ECC
nvidia-smi --query-gpu=ecc.errors.corrected.volatile.total,ecc.errors.uncorrected.volatile.total --format=csv
```

Actions:

- Alert on sudden ECC spikes
- Quarantine GPU on uncorrectable ECC
- Track error growth trends per GPU

### 1.2 Xid Event Monitoring

Xid errors indicate driver or hardware instability.

Monitor:

- Repeated Xid codes
- Memory-related Xid errors
- PCIe-related Xid errors

Commands:

```bash
dmesg | grep -i xid
journalctl -k | grep -i nvrm
```

Repeated Xid events on the same GPU → mark for investigation.

### 1.3 Thermal and Power Anomalies

Monitor:

- Temperature variance
- Power draw deviation
- Thermal throttling

Command:

```bash
nvidia-smi --query-gpu=temperature.gpu,power.draw --format=csv
```

Unexpected deviation from similar GPUs can signal instability.

## 2. Runtime-Level Detection
### 2.1 MFU Drift (Model FLOP Utilization)

Track:

- MFU per workload
- MFU consistency across replicas
- Sudden drops or divergence in MFU can indicate underlying hardware instability.

### 2.2 Determinism Checks (Training Workloads)

For distributed training:

- Compare gradient norms across ranks
- Validate reproducibility on small subsets
- Verify checkpoint integrity

Watch for:

- Rank divergence
- Unexpected NaNs
- Non-reproducible results

### 2.3 Collective Communication Monitoring

Inspect logs for:

- NCCL warnings
- AllReduce timeouts
- Collective mismatches

Example patterns:

- NCCL WARN
- AllReduce timeout
- Collective mismatch

Collective instability can silently corrupt distributed training.

## 3. Inference-Level Detection
### 3.1 Output Drift Monitoring

Track:

- Output consistency for deterministic inputs
- Embedding stability
- Replica divergence
- Identical replicas producing inconsistent outputs may signal corruption.

### 3.2 SLA Degradation Without Load Change

If:

- Latency increases
- Error rate rises
- Throughput drops

Without traffic spike → investigate GPU health.  SDC often manifests first as subtle performance anomalies.

## 4. Fleet-Level Pattern Detection

At scale, rare errors become predictable risks.  Track fleet-wide:

- GPUs with increasing ECC trends
- Clusters with abnormal instability density
- Correlation between workload types and hardware faults

Example GPU health scoring model:

```bash
health_score =
   ECC_weight × ecc_error_rate +
   Xid_weight × xid_frequency +
   thermal_weight × temperature_variance
```

Use health score to:

- Restrict placement into reserved tiers
- Move unstable GPUs to best-effort tier
- Trigger quarantine workflows

## 5. Early Warning Signals

Investigate immediately when you observe:

- Growing retired memory pages
- Repeated GPU resets
- Sudden MFU drops
- Divergent training checkpoints
- Inference replicas behaving inconsistently
- SLA degradation without demand increase

## 6. Incident Response Procedure

If SDC is suspected:

- Drain GPU from production
- Capture diagnostic logs
- Snapshot workload state
- Re-run minimal validation workload
- Quarantine GPU if instability confirmed
- Notify affected tenants if required

Never silently recycle unstable hardware.

## Summary

Silent Data Corruption is:

- Rare per device
- Predictable at fleet scale
- High impact in shared environments

Effective detection requires:

- Hardware telemetry
- Runtime validation
- Fleet-wide monitoring

Integration into governance workflows

SDC detection is not just observability —  it must inform placement, tiering, and quarantine decisions in GPUaaS platforms.
