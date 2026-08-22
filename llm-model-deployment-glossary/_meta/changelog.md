
## 2026-08-22

### Added
- New decoding-strategy and cache-reuse terms:
  - Beam Search
  - Self-Speculative Decoding (Medusa, EAGLE, lookahead decoding)
  - LMCache
  - Token Maxing

### Fixed
- `llm-d` previously defined as a generic "LLM Daemon" node-runtime concept. Corrected to
  describe the actual project: a Kubernetes-native framework for disaggregated
  prefill/decode vLLM serving with KV-cache-aware cluster routing.

## 2026-01-20

### Added
- Initial glossary structure and metadata:
  - `_meta/taxonomy.md`
  - `_meta/style-guide.md`
  - `_meta/changelog.md`
- Top-level `README.md` describing scope, philosophy, and contribution model

- Core execution and control-plane terms:
  - Autoscaling  
  - Batching  
  - Cold Start  
  - KV Cache  
  - OOM (Out of Memory)  
  - Paged Attention  
  - Prefix Caching  
  - Scheduler  
  - Serverless Architecture  
  - Speculative Decoding  
  - Tensor Parallelism  
  - TPOT (Time Per Output Token)  
  - TTFT (Time To First Token)  
  - Warm Pool  

### Taxonomy
- Established primary categories:
  - Execution  
  - Serving  
  - Control Plane / Orchestration  
  - GPU & Memory  
  - Distributed Parallelism  
  - Scheduling & Admission  
  - Performance & Metrics  
  - Reliability & Failure Modes  

- Established standard entry template and style rules

### Notes
- This release establishes the initial semantic baseline for LLM deployment and execution terminology.
- All future changes will be tracked relative to this version.

