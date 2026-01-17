# Symptoms of KV Cache Pressure

KV cache pressure typically appears before any crash or OOM event.

Common indicators include:

- GPU memory steadily rising under traffic
- GPU compute utilization dropping
- Effective batch size (p95) falling to 1–2
- p95 / p99 latency increasing
- Throughput flattening or decreasing

This degraded state can persist for hours or days before GPU OOM occurs.

