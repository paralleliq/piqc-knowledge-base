## Pipeline Parallelism

**Definition**

A form of model parallelism where different layers or stages of a model are placed on different devices and executed sequentially as data flows through the pipeline.

**Why it exists**

Very large models cannot fit on a single GPU. Pipeline parallelism enables execution by splitting the model across multiple devices while keeping each layer fully resident on one device.

**Where in the stack**

Execution layer / Distributed execution

**Key properties**
- Partitions the model into sequential stages  
- Each stage runs on a different GPU or node  
- Micro-batching overlaps computation across stages  
- Introduces pipeline bubbles and scheduling complexity  
- Latency proportional to number of pipeline stages  

**Common pitfalls**
- Pipeline bubbles reduce effective utilization  
- Imbalanced stage partitioning creates stragglers  
- Increases end-to-end latency for single requests  
- Hard to combine with dynamic batching and serving workloads  
- Failures in one stage stall the entire pipeline  

**Related terms**
- Tensor parallelism  
- Data parallelism  
- Model parallelism  
- Micro-batching  
- Pipeline bubble  
- Inter-stage communication  

**In practice**

In large-model deployments, pipeline parallelism is often combined with tensor parallelism to fit 70B+ models across multiple GPUs, at the cost of higher latency and more complex scheduling.

