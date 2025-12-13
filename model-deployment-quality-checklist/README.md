A structured checklist to evaluate model deployment correctness, performance,
reliability, scalability, and cost efficiency.

---

## 1. Model Configuration

- [ ] Model identifier (id/family/task/framework) is correct
- [ ] Precision (fp16/bf16/int8) is explicitly configured
- [ ] Max sequence length is appropriate for expected inputs
- [ ] Max generation length is defined
- [ ] Tokenizer configuration is correct and consistent
- [ ] Model artifacts (weights, tokenizer, config) are versioned
- [ ] Model URI paths resolve correctly (S3/GCS/local)

---

## 2. Runtime & Hardware Alignment

- [ ] GPU type matches model requirements
- [ ] GPU memory is adequate for max batch × max sequence length
- [ ] Tensor parallel and pipeline parallel settings are valid
- [ ] GPU count matches configuration in orchestration layer
- [ ] CPU and memory allocations support preprocessing/postprocessing
- [ ] Environment variables required by the model runtime are set

---

## 3. Serving Configuration

- [ ] Serving protocol (HTTP/GRPC) is explicitly defined
- [ ] Port configuration is correct
- [ ] Max concurrency value is set and model-appropriate
- [ ] Timeout settings reflect worst-case prompt/generation sizes
- [ ] Readiness probe path returns 200 and verifies model health
- [ ] Liveness probe detects hangs or dead model workers
- [ ] Default batch size and max batch size are set

---

## 4. Scaling & Performance

- [ ] MinReplicas and MaxReplicas are defined
- [ ] Autoscaling strategy (reactive/predictive/manual) is set
- [ ] Scaling metrics reflect ML workloads (not CPU only)
- [ ] Target latency P95/P99 values are defined
- [ ] Warm pool size supports cold-start-sensitive models
- [ ] GPU utilization is monitored for under/over-utilization
- [ ] Batch scheduling behavior is validated (LLM-specific)

---

## 5. Observability & Logging

- [ ] Metrics endpoint is enabled
- [ ] Metrics provider (Prometheus/OTel) is configured
- [ ] Logs include request ID / trace ID
- [ ] Logging level is set appropriately (INFO/ERROR)
- [ ] Tracing is enabled if required
- [ ] Latency, token throughput, and GPU metrics are exported
- [ ] Error codes and failure modes are captured and labeled

---

## 6. Preprocessing & Postprocessing

- [ ] Preprocessing steps are defined and deterministic
- [ ] Tokenization settings match model configuration
- [ ] Postprocessing steps (reranking, formatting, filtering) are defined
- [ ] Each step is tested independently and in sequence
- [ ] Optional steps correctly handle `enabled=false`

---

## 7. Dependency Graph (Model-to-Model Interactions)

- [ ] Upstream dependencies are defined (guardrails, rerankers, retrievers)
- [ ] Each dependency includes input/output type contracts
- [ ] Latency budgets are defined for dependency calls
- [ ] Optional dependencies are correctly marked as non-required
- [ ] specRef paths resolve correctly
- [ ] Circular dependencies do not exist
- [ ] Data formats between nodes are validated

---

## 8. Safety, Compliance & Governance

- [ ] PII handling policy (allowed/disallowed) is defined
- [ ] Retention policy for logs and artifacts is set
- [ ] Governance owner is assigned
- [ ] Change approval workflow is documented
- [ ] Safety filters or guardrails are connected and active
- [ ] Input/output filtering meets org policy

---

## 9. Cost Controls

- [ ] Target cost per request or per 1k tokens is defined
- [ ] Instance type and GPU class match cost constraints
- [ ] Spot instance usage is explicitly allowed/disabled
- [ ] Scaling rules prevent runaway costs
- [ ] Cross-model cost attribution is monitored
- [ ] Batch and throughput settings are optimized for cost/latency tradeoff

---

## 10. Release Engineering & Versioning

- [ ] Model version and runtime version are pinned
- [ ] Image tag is immutable (no `latest`)
- [ ] Rollout strategy is defined (canary/blue-green/shadow)
- [ ] Compatibility with previous versions is verified
- [ ] Rollback procedure is tested
- [ ] ModelSchema/ModelSpec validity check passes