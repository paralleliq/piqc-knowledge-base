# LLM Inference Architecture

Modern LLM inference engines separate execution into two phases:

1. Prefill engine
2. Decode engine

                +------------------+
User Request →  |   Scheduler      |
                +------------------+
                         |
                         v
                +------------------+
                | Prefill Engine   |
                | (FlashAttention) |
                +------------------+
                         |
                         v
                +------------------+
                | KV Cache Manager |
                +------------------+
                         |
                         v
                +------------------+
                | Decode Engine    |
                | (Continuous      |
                |  batching)       |
                +------------------+
                         |
                         v
                +------------------+
                | Token Streamer   |
                +------------------+
