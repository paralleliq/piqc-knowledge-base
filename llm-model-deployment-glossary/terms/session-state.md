## Session State

**Definition**

Context that must persist across multiple requests belonging to the same conversation or interaction — most importantly, whatever KV cache or conversation history is needed to continue generating coherently on the next turn.

**Why it exists**

Multi-turn interactions (chat, agentic workflows) need the model to have access to prior turns, not just the current message. Something has to hold that context between requests — either by resending the full history each time and recomputing, or by keeping cache or state around so the next turn doesn't start from scratch. How a system handles session state determines both correctness (does the model actually remember the conversation) and cost (does every turn re-pay full prefill).

**Where in the stack**

Serving layer

**Key properties**
- Can be handled entirely client-side (resend full history every request) or server-side (retain KV cache or state between turns)
- Server-side retention trades memory for lower per-turn latency, since prefix caching or persisted KV cache avoids recomputing shared history
- Stateless serving (no server-side retention) is simpler to scale and load-balance, since any replica can handle any request
- Stateful session retention ties a conversation to a specific replica or cache location, complicating load balancing and failover
- LMCache-style cross-engine cache sharing is one way to get session-state benefits without pinning a session to a single replica

**Common pitfalls**
- Pinning sessions to specific replicas for state locality creates load-imbalance risk if session distribution across replicas is uneven
- A replica failure mid-session can lose server-side state entirely if it isn't replicated or persisted elsewhere
- Naive full-history resend on every turn re-pays prefill cost for the entire conversation each time, which prefix caching is specifically meant to avoid
- Confusing session state (conversation-level context) with request-level state (a single request's KV cache during its own generation) leads to unclear ownership of what persists and for how long
- Not setting an expiration or eviction policy for idle sessions, letting stale session state consume cache indefinitely

**Related terms**
- Prefix caching
- KV cache
- Stateless serving
- LMCache
- Streaming
- Cache eviction

**In practice**

A chat application that resends full conversation history on every turn pays full prefill cost each time; the same application backed by prefix caching or persisted session state only pays prefill for the new turn's tokens, dramatically reducing per-turn latency and cost in long conversations.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
