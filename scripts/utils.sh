#!/bin/bash

# Bitcoin Regtest Network - Utility Functions

# RPC credentials
RPC_USER="bitcoin"
RPC_PASSWORD="bitcoin123"
NODE1_PORT="18443"
NODE2_PORT="18453"

# RPC call function
rpc_call() {
    local node_port=$1
    local method=$2
    local params=$3
    local wallet_name=$4
    
    if [ -z "$params" ]; then
        params="[]"
    fi
    
    local endpoint="http://localhost:${node_port}"
    if [ -n "$wallet_name" ]; then
        endpoint="${endpoint}/wallet/${wallet_name}"
    fi
    
    curl -s -u "${RPC_USER}:${RPC_PASSWORD}" \
         -X POST "$endpoint" \
         -H "Content-Type: application/json" \
         -d "{\"jsonrpc\":\"1.0\",\"id\":\"rpc\",\"method\":\"${method}\",\"params\":${params}}"
}

# Check if node is responsive
check_node() {
    local node_port=$1
    local response=$(rpc_call "$node_port" "getblockchaininfo")
    echo "$response" | grep -q '"chain":"regtest"'
}

# Get block count
get_blocks() {
    local node_port=$1
    local response=$(rpc_call "$node_port" "getblockchaininfo")
    echo "$response" | grep -o '"blocks":[0-9]*' | cut -d':' -f2
}

# Create wallet if needed
ensure_wallet() {
    local node_port=$1
    local wallet_name="node${node_port}wallet"
    local wallets=$(rpc_call "$node_port" "listwallets")
    if ! echo "$wallets" | grep -q "\"$wallet_name\""; then
        rpc_call "$node_port" "createwallet" "[\"$wallet_name\"]" >/dev/null
    fi
}

# Get new address
get_address() {
    local node_port=$1
    local wallet_name="node${node_port}wallet"
    ensure_wallet "$node_port"
    local response=$(rpc_call "$node_port" "getnewaddress" "[]" "$wallet_name")
    echo "$response" | grep -o '"result":"[^"]*"' | cut -d'"' -f4
}

# Get balance
get_balance() {
    local node_port=$1
    local wallet_name="node${node_port}wallet"
    ensure_wallet "$node_port"
    local response=$(rpc_call "$node_port" "getbalance" "[]" "$wallet_name")
    echo "$response" | grep -o '"result":[0-9.]*' | cut -d':' -f2
}