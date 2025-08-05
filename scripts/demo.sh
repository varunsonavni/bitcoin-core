#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

echo "Bitcoin Regtest Network Demo"
echo "============================"

# Step 1: Start containers
echo "1. Starting containers..."
cd "${SCRIPT_DIR}/.." && make up

# Step 2: Connect nodes
echo "2. Connecting nodes..."
"${SCRIPT_DIR}/setup-network.sh"

echo ""
echo "3. Mining 101 blocks..."
"${SCRIPT_DIR}/mine-blocks.sh" 101

echo ""
echo "4. Sending transaction 1..."
"${SCRIPT_DIR}/send-transaction.sh" 18443 18453 5.0

echo ""
echo "5. Sending transaction 2..."
"${SCRIPT_DIR}/send-transaction.sh" 18453 18443 2.5

echo ""
echo "Demo completed!"
echo "==============="
echo "Node1: $(get_blocks "18443") blocks, $(get_balance "18443") BTC"
echo "Node2: $(get_blocks "18453") blocks, $(get_balance "18453") BTC"