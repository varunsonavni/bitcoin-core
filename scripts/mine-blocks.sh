#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

BLOCKS=${1:-101}
NODE_PORT=${2:-$NODE1_PORT}

if [ "$BLOCKS" -lt 1 ]; then
    echo "Usage: $0 [blocks] [node_port]"
    echo "Example: $0 101 18443"
    exit 1
fi

echo "Mining $BLOCKS blocks..."

# Check node
if ! check_node "$NODE_PORT"; then
    echo "ERROR: Node not responding"
    exit 1
fi

# Get current state
BEFORE=$(get_blocks "$NODE_PORT")
ADDRESS=$(get_address "$NODE_PORT")

if [ -z "$ADDRESS" ]; then
    echo "ERROR: Could not get mining address"
    exit 1
fi

echo "Before: $BEFORE blocks"
echo "Mining to: $ADDRESS"

# Mine blocks
WALLET="node${NODE_PORT}wallet"
RESPONSE=$(rpc_call "$NODE_PORT" "generatetoaddress" "[${BLOCKS},\"${ADDRESS}\"]" "$WALLET")

if ! echo "$RESPONSE" | grep -q '"error":null'; then
    echo "ERROR: Mining failed"
    exit 1
fi

sleep 2

# Show results
AFTER=$(get_blocks "$NODE_PORT")
MINED=$((AFTER - BEFORE))
BALANCE=$(get_balance "$NODE_PORT")

echo "After: $AFTER blocks"
echo "Mined: $MINED blocks"
echo "Balance: $BALANCE BTC"
echo "Mining completed!"