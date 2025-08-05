#!/bin/bash
set -e

# Get node name from environment for logging
NODE_NAME=${NODE_NAME:-node}

# Create data directory if it doesn't exist
mkdir -p /home/bitcoin/.bitcoin

# Verify config file exists
if [ ! -f /home/bitcoin/.bitcoin/bitcoin.conf ]; then
    echo "ERROR: No bitcoin.conf found. Configuration should be mounted as volume."
    exit 1
fi

# Log startup
echo "Starting Bitcoin Core ${NODE_NAME} in regtest mode..."
echo "Using configuration: /home/bitcoin/.bitcoin/bitcoin.conf"
echo "RPC will be available on port 18443"
echo "P2P will be available on port 18444"

# Execute the command passed to the container
exec "$@"