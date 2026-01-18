# Examples: Training–Serving Skew Symptom Patterns

## Pattern A: “Same model, suddenly slower”
Common culprits:
- dtype drifted to fp32
- max model len increased
- concurrency increased
- streaming mode changed

Evidence to collect:
- args/env diff
- runtime dtype fact
- max model len fact
- tokens/sec trend + latency p99 trend

---

## Pattern B: “Quality got worse but weights unchanged”
Common culprits:
- tokenizer mismatch
- prompt formatting/preprocessing changes
- quantization enabled unexpectedly

Evidence to collect:
- tokenizer revision
- preprocessing config
- quantization mode + config

---

## Pattern C: “Staging OK, prod bad”
Common culprits:
- different GPU class
- different autoscaling signal (CPU vs tokens/latency)
- different ingress timeouts/retries

Evidence:
- GPU type + driver
- HPA config
- ingress retry/timeout policies

