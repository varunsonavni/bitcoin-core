#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

FROM_PORT=${1:-$NODE1_PORT}
TO_PORT=${2:-$NODE2_PORT}
AMOUNT=${3:-1.0}

if ! echo "$AMOUNT" | grep -qE '^[0-9]*\.?[0-9]+$'; then
    echo "Usage: $0 [from_port] [to_port] [amount]"
    echo "Example: $0 18443 18453 1.5"
    exit 1
fi

echo "Sending $AMOUNT BTC from port $FROM_PORT to port $TO_PORT"

# Check nodes
if ! check_node "$FROM_PORT"; then
    echo "ERROR: Source node not responding"
    exit 1
fi

if ! check_node "$TO_PORT"; then
    echo "ERROR: Destination node not responding"
    exit 1
fi

# Check balance
BALANCE_BEFORE=$(get_balance "$FROM_PORT")
echo "Source balance: $BALANCE_BEFORE BTC"

if (( $(echo "$BALANCE_BEFORE < $AMOUNT" | bc -l) )); then
    echo "ERROR: Insufficient balance (need $AMOUNT BTC)"
    echo "Mine blocks first: ./scripts/mine-blocks.sh 101 $FROM_PORT"
    exit 1
fi

# Get destination address
DEST_ADDRESS=$(get_address "$TO_PORT")
if [ -z "$DEST_ADDRESS" ]; then
    echo "ERROR: Could not get destination address"
    exit 1
fi

echo "Destination: $DEST_ADDRESS"

# Send transaction
FROM_WALLET="node${FROM_PORT}wallet"
TX_RESPONSE=$(rpc_call "$FROM_PORT" "sendtoaddress" "[\"${DEST_ADDRESS}\",${AMOUNT}]" "$FROM_WALLET")

if ! echo "$TX_RESPONSE" | grep -q '"error":null'; then
    echo "ERROR: Transaction failed"
    exit 1
fi

TXID=$(echo "$TX_RESPONSE" | grep -o '"result":"[^"]*"' | cut -d'"' -f4)
echo "Transaction ID: $TXID"

# Mine confirmation block
sleep 2
MINING_ADDRESS=$(get_address "$FROM_PORT")
rpc_call "$FROM_PORT" "generatetoaddress" "[1,\"${MINING_ADDRESS}\"]" "$FROM_WALLET" >/dev/null
sleep 2

# Show final balance
BALANCE_AFTER=$(get_balance "$FROM_PORT")
DEST_BALANCE=$(get_balance "$TO_PORT")

echo "Source balance after: $BALANCE_AFTER BTC"
echo "Destination balance: $DEST_BALANCE BTC"
echo "Transaction completed!"