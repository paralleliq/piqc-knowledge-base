#!/usr/bin/env bash

set -e

ROOT="gpuaas-control-plane-glossary"
TERMS_DIR="$ROOT/terms"

echo "Creating GPUaaS Control Plane Glossary scaffold..."

mkdir -p "$TERMS_DIR"

TERMS=(

# Core control plane
control-plane
governance-layer
orchestration-layer
execution-layer
intent
policy-engine
reconciliation-loop
desired-vs-actual-state
actuation
admission-gating
closed-loop-control

# Admission / scheduling
admission-control
queue
localqueue
clusterqueue
workload-admission
priority-class
preemption
fairness
quota
resource-quota
limit-range
pod-disruption-budget
gang-scheduling

# Provisioning / autoscaling
provisioning
reactive-scaling
proactive-scaling
autoscaler
cluster-autoscaler
karpenter
nodepool
nodeclaim
warm-pool
capacity-buffer
scale-up
scale-down
consolidation
drain
cordon

# GPU specific
gang-provisioning
idle-rank
cold-start
fragmentation
bin-packing
gpu-shape
topology-aware-scheduling
placement-constraints
gpu-utilization
oversubscription
reservation
reclaim
spot-interruption
gpu-affinity
device-plugin

# Serving / networking
gateway-api
inference-api
service
load-balancing
horizontal-pod-autoscaler
vertical-pod-autoscaler
traffic-shaping

# Telemetry / signals
observability
metrics
alerting
alertmanager
webhook
events
slo
sla
utilization
queue-depth
provisioning-latency

# Operational workflows
tenant-onboarding
capacity-rebalancing
incident-management
cost-optimization
platform-upgrade
capacity-planning
metering
chargeback
security-isolation
)

create_file () {
  local name=$1
  local file="$TERMS_DIR/$name.md"

  if [[ -f "$file" ]]; then
    echo "Skipping existing $file"
    return
  fi

  title=$(echo "$name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

  cat > "$file" <<EOF
# $title

## Definition
TODO: Add concise definition.

## Why it matters in GPUaaS
TODO: Explain impact on scheduling, provisioning, or control plane behavior.

## Related terms
TODO
EOF

  echo "Created $file"
}

for term in "${TERMS[@]}"; do
  create_file "$term"
done

# Create README if missing
README="$ROOT/README.md"
if [[ ! -f "$README" ]]; then
cat > "$README" <<EOF
# GPUaaS Control Plane Glossary

A reference glossary for concepts, primitives, and operational patterns
used when building and operating multi-tenant GPU infrastructure and AI control planes.

Each term lives under \`terms/\` as a standalone markdown file.
EOF
fi

echo ""
echo "✅ Done."
echo "Location: $ROOT/"
echo ""

