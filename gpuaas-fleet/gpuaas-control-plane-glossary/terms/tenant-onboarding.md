# Tenant Onboarding

## Definition
Tenant onboarding is the process of registering a new customer or team with the platform and setting up the policies, quotas, queues, and infrastructure needed for them to safely and fairly use shared GPU capacity.

It establishes the tenant’s identity, limits, and service tier before any workloads are allowed to run.

In GPUaaS, onboarding defines *who they are, what they can use, and how they are treated*.

## Why it matters in GPUaaS
GPU clusters are multi-tenant and capacity is expensive. Without structured onboarding:

- tenants may overconsume resources
- fairness breaks down
- accounting is unclear
- policies are inconsistent
- security risks increase

Onboarding ensures every tenant starts with:
- clear limits
- proper isolation
- predictable behavior
- enforceable contracts

It is the foundation for governance and cost control.

## Responsibilities
Tenant onboarding typically sets up:

### Identity
- tenant ID
- namespace(s)
- authentication/authorization
- RBAC permissions

### Policy
- service tier (prod, standard, best-effort)
- priority class
- quotas and limits
- reclaim/preemption eligibility
- SLA/SLO targets

### Scheduling / admission
- LocalQueue association
- ClusterQueue mapping
- capacity pools they can use

### Capacity controls
- max GPUs
- allowed GPU shapes
- node pools
- warm pool or reserved capacity (if applicable)

### Accounting
- metering
- billing tags
- chargeback tracking

## Typical workflow
1. tenant signs contract or selects tier
2. governance layer defines limits and policies
3. orchestration layer creates Kubernetes artifacts:
   - namespace
   - ResourceQuota
   - PriorityClass
   - LocalQueue
   - access rules
4. tenant receives credentials
5. tenant can request capacity and run workloads

After onboarding, runtime flows (request capacity → deploy model) apply.

## Example
Tenant signs up for:
- up to 10 H100 GPUs
- best-effort tier
- no startup SLA

System provisions:
- namespace
- 10-GPU quota
- low priority class
- associated LocalQueue

Their workloads run within those constraints.

## Manual vs automated
Modern platforms automate onboarding using:
- templates
- GitOps
- controllers
- self-service portals

Manual steps should be minimal.

## Mental model
Tenant onboarding is creating a “lane and rulebook” for a customer before they enter the shared highway.

## Related terms
- [Governance Layer](./governance-layer.md)
- [Quota](./quota.md)
- [LocalQueue](./localqueue.md)
- [ClusterQueue](./clusterqueue.md)
- [Priority Class](./priority-class.md)
- [SLA](./sla.md)

