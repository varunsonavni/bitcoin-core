#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

echo "Connecting Bitcoin regtest nodes..."

# Check both nodes are running
if ! check_node "$NODE1_PORT"; then
    echo "ERROR: Node1 failed to start"
    exit 1
fi

if ! check_node "$NODE2_PORT"; then
    echo "ERROR: Node2 failed to start"
    exit 1
fi

echo "Both nodes are running"

# Get node2 IP and connect nodes
NODE2_IP=$(docker inspect bitcoin-node2 --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 2>/dev/null)
if [ -n "$NODE2_IP" ]; then
    echo "Connecting nodes..."
    rpc_call "$NODE1_PORT" "addnode" "[\"${NODE2_IP}:18444\",\"add\"]" >/dev/null
    sleep 2
fi

# Show status
echo ""
echo "Network Status:"
echo "Node1: $(get_blocks "$NODE1_PORT") blocks"
echo "Node2: $(get_blocks "$NODE2_PORT") blocks"
echo ""
echo "Network ready!"
echo "Mine blocks: make mine"
echo "Send transaction: make send"