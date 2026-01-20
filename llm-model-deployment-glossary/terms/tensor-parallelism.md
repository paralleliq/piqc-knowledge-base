## Tensor Parallelism

**Definition**

A form of model parallelism where individual tensor operations are split across multiple devices, and each device computes a shard of the same layer in parallel.

**Why it exists**

Single GPUs cannot hold or efficiently compute very large model layers. Tensor parallelism enables large models to scale by distributing matrix multiplications and attention operations across multiple GPUs.

**Where in the stack**

Execution layer / Distributed execution

**Key properties**
- Splits weight matrices and activations across devices  
- Requires collective communication (e.g., all-reduce, all-gather)  
- Preserves layer semantics while distributing compute  
- Scales compute and memory capacity linearly with GPUs  
- Strongly dependent on interconnect bandwidth and latency  

**Common pitfalls**
- Communication overhead dominates at small batch sizes  
- Poor interconnect causes severe scaling inefficiency  
- Incorrect sharding leads to imbalance and stragglers  
- Hard to combine efficiently with dynamic batching  
- Failures or slow devices stall the entire group  

**Related terms**
- Model parallelism  
- Pipeline parallelism  
- Data parallelism  
- All-reduce  
- Collective communication  
- Interconnect bandwidth  

**In practice**

In inference for 70B+ models, tensor parallelism is commonly used to shard attention and feedforward layers across 2–8 GPUs, trading increased communication for the ability to fit and execute the model.


