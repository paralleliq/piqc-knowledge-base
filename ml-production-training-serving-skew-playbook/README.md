# Training–Serving Skew Playbook (Configuration Mismatch)

Training–serving skew is when the model that runs in production is not executed under the same assumptions
as the model that was trained, validated, or benchmarked—often without any explicit crash.

This playbook helps you:
- detect skew quickly
- identify where mismatch is happening (model, runtime, hardware, serving, orchestration)
- apply safe mitigations
- prevent recurrence with “contract-style” configuration (for example, [ModelSpec](https://github.com/paralleliq/modelspec))


## When to use this
Use this playbook if you observe:
- unexplained latency/throughput regressions after a rollout
- quality regressions with no weight changes
- GPU cost spikes despite “same” model
- differences between staging and prod behavior

## Quick links
- [Diagnostics](diagnostics.md)
- [Emergency Mitigation](emergency-mitigation.md)
- [Prevention](prevention.md)

## What “skew” typically means in practice
Common mismatch categories:
- **Model artifacts**: wrong weights, tokenizer, revision, or config
- **Runtime**: dtype, quantization, batching, max context, concurrency, scheduling settings
- **Hardware**: different GPU class, VRAM, interconnect, driver/CUDA stack
- **Serving**: timeouts, streaming mode, request size limits, retries
- **Orchestration**: autoscaling metrics, pod resources, node affinity, warm pools

## Evidence mindset (important)
To avoid guesswork, aim to collect:
- “what we intended” (declared config, chart values, ModelSpec)
- “what is actually running” (runtime flags/env, live pod specs, metrics)
- “what changed” (diffs between last-good and current)

If you can’t show a difference, you’re not done debugging.

