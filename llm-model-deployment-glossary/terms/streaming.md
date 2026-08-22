## Streaming

**Definition**

Delivering generated tokens to the client incrementally as they're produced, rather than waiting for the full response to complete before sending anything back.

**Why it exists**

LLM generation is inherently incremental — tokens come out one at a time during decode. Waiting for the entire response before sending anything means the client experiences the full generation latency as dead time, even though the first tokens were ready much earlier. Streaming exposes that incremental production directly to the client, so perceived latency tracks TTFT instead of total generation time.

**Where in the stack**

Serving layer

**Key properties**
- Perceived latency becomes dominated by TTFT rather than total generation time, since the client sees output as it's produced
- Requires the serving layer to hold the connection open for the duration of generation, changing connection lifecycle management compared to a single request/response
- Typically implemented via server-sent events or chunked HTTP responses, one chunk per token or small token group
- Decouples user-perceived responsiveness from TPOT — even a moderate TPOT feels fine if tokens are visibly arriving continuously
- Interacts with session state — a streamed connection is a longer-lived resource on both server and load balancer than a simple request/response

**Common pitfalls**
- Load balancers or proxies with default timeouts tuned for short request/response cycles cutting off long streaming connections prematurely
- Client-side buffering that defeats the purpose by waiting for multiple chunks before rendering, reintroducing the latency streaming was meant to hide
- Not accounting for the higher concurrent connection count streaming produces compared to fast request/response cycles when sizing load balancers or gateways
- Treating a streaming connection's open duration as idle time in connection-count-based capacity planning, when it's actually attached to active decode work
- Losing visibility into true completion latency because dashboards only track TTFT once streaming is in place, missing degraded TPOT mid-stream

**Related terms**
- TTFT
- TPOT
- Session state
- Decode
- Queueing delay
- Tail latency

**In practice**

A chat interface using streaming feels responsive even with a moderate TPOT because the user sees tokens appearing continuously from TTFT onward — switching that same backend to a non-streaming response would expose the full generation time as a single upfront wait.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
