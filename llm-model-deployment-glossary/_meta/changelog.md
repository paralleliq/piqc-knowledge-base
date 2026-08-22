
## 2026-08-22

### Added
- New decoding-strategy and cache-reuse terms:
  - Beam Search
  - Self-Speculative Decoding (Medusa, EAGLE, lookahead decoding)
  - LMCache
  - Token Maxing

- Core execution terms that were referenced throughout the glossary's "Related terms"
  sections but never had their own entry:
  - Continuous Batching
  - Prefill
  - Decode
  - Draft Model

- GPU & memory and distributed parallelism terms named as taxonomy examples but missing:
  - Memory Fragmentation
  - GPU HBM
  - MIG (Multi-Instance GPU)
  - Block Allocator
  - Data Parallelism
  - All-Reduce
  - Collective Communication

- Scheduling, admission, and performance-metric terms:
  - Admission Control
  - Active Sequences
  - Head-of-Line Blocking
  - Tokens Per Second (TPS)
  - Tail Latency
  - Effective Batch Size

- Reliability and serving terms:
  - Thrashing
  - Cascading Restart
  - Retry Storm
  - Queueing Delay
  - Streaming
  - Session State

- Control plane terms:
  - Scale-to-Zero
  - Provisioning Latency

- Ecosystem terms drawn from the platform's fact-taxonomy ecosystem notes, not previously
  in the glossary at all:
  - Quantization
  - Mixture of Experts (MoE)
  - Chunked Prefill
  - MPS (Multi-Process Service)
  - Time-Slicing
  - SGLang
  - DCGM (Data Center GPU Manager)
  - Triton Inference Server
  - TensorRT-LLM
  - LoRA Serving
  - OpenTelemetry
  - TGI (Text Generation Inference)
  - Disaggregated Prefill/Decode

### Fixed
- `llm-d` previously defined as a generic "LLM Daemon" node-runtime concept. Corrected to
  describe the actual project: a Kubernetes-native framework for disaggregated
  prefill/decode vLLM serving with KV-cache-aware cluster routing.

### Notes
- This closes essentially every dangling cross-reference in the pre-existing entries, plus
  every term named as a category example in `_meta/taxonomy.md`.

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

