## LLMD (LLM Daemon)

**Definition**

A long-running process responsible for managing model loading, GPU memory, scheduling, and execution of LLM inference requests on a node.

**Why it exists**

Model execution requires persistent state (weights, KV cache, memory pools) and tight control over GPU resources that cannot be efficiently managed by short-lived processes.

**Where in the stack**

Execution layer / Node-level runtime

**Key properties**
- Owns GPU memory allocations and model weights  
- Manages request scheduling and batching internally  
- Maintains KV cache and active sequence state  
- Serves as the execution backend for serving layers  
- Long-lived and stateful by design  

**Common pitfalls**
- Restarting the daemon causes full model reload and cold start  
- Memory leaks accumulate across long runtimes  
- Poor isolation between tenants or models  
- Health checks report healthy while execution is degraded  
- Coupling serving logic too tightly with daemon internals  

**Related terms**
- Execution engine  
- Model loading  
- KV cache  
- Continuous batching  
- Serving layer  
- Runtime  

**In practice**

In systems like vLLM, the LLMD manages batching, scheduling, and KV cache while the HTTP server acts as a thin serving layer on top.

