# LLM Model Deployment Glossary

A curated, execution-grade glossary of terms used in large-language-model (LLM) deployment, serving, and GPU infrastructure.

This glossary focuses on **how models actually run in production** — execution semantics, memory behavior, scheduling, scaling, latency, and failure modes — not high-level ML theory.

It is intended as a shared vocabulary for:

- ML platform engineers  
- Infrastructure and systems engineers  
- GPU cluster operators  
- ML engineers deploying large models  
- Architects designing serving and control planes  

---

## Why this glossary exists

Modern LLM systems fail not because models are wrong, but because:

- memory pressure is misunderstood  
- batching and scheduling interact badly  
- autoscaling arrives too late  
- cold starts dominate latency  
- metrics hide real bottlenecks  

Teams often lack a **precise, shared vocabulary** to reason about these systems.

This glossary aims to:

- standardize terminology across execution, serving, and control planes  
- document real operational behavior and failure modes  
- provide a reference layer for playbooks, checklists, and tooling  
- bridge research concepts with production reality  

---

## Scope

This glossary covers concepts across the full deployment stack:

- Execution semantics (prefill, decode, KV cache, paging)  
- Scheduling and batching  
- GPU memory management  
- Distributed parallelism  
- Autoscaling and provisioning  
- Latency and throughput metrics  
- Reliability and failure modes  

Out of scope:

- Model architectures and training theory  
- Prompt engineering  
- Application-level UX concepts  

---

## Structure

Glossary entries are organized by conceptual layer rather than alphabetically.

Primary categories (see `_meta/taxonomy.md`):

- Execution  
- Serving  
- Control Plane / Orchestration  
- GPU & Memory  
- Distributed Parallelism  
- Scheduling & Admission  
- Performance & Metrics  
- Reliability & Failure Modes  

Each term follows a strict template:

- Definition  
- Why it exists  
- Where in the stack  
- Key properties  
- Common pitfalls  
- Related terms  
- In practice  

This ensures entries remain:

- concise  
- operational  
- comparable across concepts  

---

## How to use this glossary

### For practitioners
Use this as a reference when:

- debugging latency or throughput issues  
- reasoning about autoscaling failures  
- designing serving architectures  
- explaining system behavior to partners or stakeholders  

### For teams
Use this as:

- onboarding material  
- a shared vocabulary in design docs  
- a reference for playbooks and runbooks  
- a foundation for internal standards  

### For tooling
The glossary is designed to be:

- machine-indexable  
- taxonomy-aware  
- compatible with future rule engines and advisors  

---

## Current core concepts

Examples of foundational terms included:

- Autoscaling  
- Batching  
- Cold Start  
- KV Cache  
- Paged Attention  
- Scheduler  
- Tensor Parallelism  
- TTFT (Time To First Token)  
- TPOT (Time Per Output Token)  
- Warm Pool  

See individual term files for details.

---

## Contributing

Contributions are welcome, but precision matters.

Before adding or editing a term:

1. Read `_meta/style-guide.md`  
2. Follow the standard entry template  
3. Assign exactly one primary category  
4. Add related terms and pitfalls  

Preferred contributions:

- execution semantics  
- memory behavior  
- scheduling and control plane concepts  
- real failure modes  
- production metrics  

Avoid:

- marketing language  
- vendor-specific framing  
- speculative or unverified claims  

---

## Versioning and changes

All notable changes are tracked in:

- `_meta/changelog.md`

Definitions may evolve as systems and practices mature.

---

## Design philosophy

This glossary is:

- execution-first  
- vendor-neutral  
- production-oriented  
- failure-aware  

It reflects how systems behave under:

- memory pressure  
- burst traffic  
- scaling events  
- tail latency regimes  

---

## License

Unless otherwise noted, this glossary is released under an open license suitable for reuse in documentation, tooling, and internal standards.

---

## Acknowledgment

This glossary is inspired by real production systems and operational experience across:

- GPU-heavy inference clusters  
- Kubernetes-based serving platforms  
- vLLM, Triton, TensorRT-LLM, and related runtimes  
- Distributed parallel execution environments  

The goal is to make LLM infrastructure **legible, debuggable, and predictable**.
