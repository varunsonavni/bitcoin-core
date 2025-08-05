# Bitcoin Regtest Network with Docker

A Docker-based setup for running a private Bitcoin regtest network with at least 2 nodes, paired together for block mining and transaction processing.

## Overview

This system implements the following requirements:
- **Launch a private Bitcoin Network (regtest)** with at least 2 nodes using Docker and bash
- **Pair nodes between each other** for network connectivity
- **Mine blocks** on the regtest network
- **Send transactions** from one node to another
- **Support multiple runs** with new transactions each time
- **Well-documented examples** of all operations

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd bitcoin-core

# 1. Start the Bitcoin containers
make up

# 2. Connect the nodes together
make setup

# 3. Mine blocks to generate spendable Bitcoin  
make mine

# 4. Send a transaction between nodes
make send

# 5. Stop when done
make clean
```

## Requirements

- Docker and Docker Compose
- Bash (Unix/Linux environment)
- `curl` and `bc` (for RPC calls and calculations)

## Project Structure

```
bitcoin-core/
├── README.md                 # This documentation
├── Makefile                  # Container management commands
├── docker/
│   ├── Dockerfile           # Bitcoin Core 28.1 container
│   ├── docker-compose.yml   # 2-node orchestration
│   └── entrypoint.sh        # Container startup script
├── scripts/                  # Main operation scripts
│   ├── setup-network.sh     # Network setup and node pairing
│   ├── mine-blocks.sh       # Block mining functionality
│   ├── send-transaction.sh  # Transaction creation and broadcast
│   ├── demo.sh              # Complete workflow demonstration
│   └── utils.sh             # Helper functions for RPC calls
└── config/
    ├── bitcoin1.conf        # Node 1 configuration
    └── bitcoin2.conf        # Node 2 configuration
```

## Step-by-Step Usage Guide

### 1. Container Management

**Purpose**: Start and manage the Bitcoin Docker containers.

```bash
# Start the Bitcoin network containers
make up

# Check container status
make status

# View container logs
make logs

# Stop containers when done
make clean
```

**What happens:**
- Docker Compose builds Bitcoin Core 28.1 containers
- Starts 2 nodes with separate data volumes
- Creates isolated network for node communication
- Exposes RPC ports: 18443 (node1), 18453 (node2)

### 2. Connect Nodes Together

**Purpose**: Pair the running Bitcoin nodes for P2P communication.

```bash
# Connect the nodes together
make setup

# Output example:
# Connecting Bitcoin regtest nodes...
# Both nodes are running
# Connecting nodes...
# 
# Network Status:
# Node1: 0 blocks
# Node2: 0 blocks
# 
# Network ready!
```

**What happens:**
1. **Health Checks**: Verifies both nodes respond to RPC calls
2. **Node Pairing**: Connects node1 to node2 via P2P network
3. **Status Report**: Shows current blockchain state
4. **Ready Confirmation**: Nodes are paired and ready for Bitcoin operations

### 3. Mining Blocks Example

**Purpose**: Mine blocks on the Bitcoin regtest network to generate spendable Bitcoin for transactions.

```bash
# Mine 101 blocks (minimum for coinbase maturity in regtest)
make mine

# Output example:
# Mining 101 blocks...
# Before: 0 blocks
# Mining to: bcrt1qfhgv82k5q72gq7mhqlyght3phmj4cavkagcgxj
# After: 101 blocks
# Mined: 101 blocks
# Balance: 250.00000000 BTC
# Mining completed!
```

**What happens:**
- Script checks node connectivity
- Creates a wallet automatically if needed
- Generates a new Bitcoin address for mining rewards
- Mines the specified number of blocks
- Each block rewards 50 BTC in regtest mode
- Shows before/after block count and resulting balance

**Key benefits:**
- Generates spendable Bitcoin for testing transactions
- Fast mining (seconds vs. 10 minutes on mainnet)
- Automatic wallet management
- Clear progress reporting

### 4. Sending Transactions Example

**Purpose**: Send Bitcoin from one node to another, demonstrating cross-node transactions.

```bash
# Send 5.0 BTC from node1 (port 18443) to node2 (port 18453)
make send

# Output example:
# Sending 5.0 BTC from port 18443 to port 18453
# Source balance: 250.00000000 BTC
# Destination: bcrt1qdk73z8gd27u8p8dd7mwk6v3y4mtpsxcvlk3ht6
# Transaction ID: 0f094ba322c8fe40dfbd511fd5cca0c69611271ced96e2017d22cde83ad46ed9
# Source balance after: 296.99998590 BTC
# Destination balance: 0.00000000 BTC
# Transaction completed!
```

**What happens:**
1. **Validation**: Checks both nodes are responsive
2. **Balance Check**: Verifies sufficient funds (250 BTC available)
3. **Address Generation**: Creates new address on destination node
4. **Transaction Creation**: Sends 5.0 BTC with transaction fee
5. **Confirmation**: Mines a block to confirm the transaction
6. **Mining Reward**: Source gets 50 BTC reward for mining confirmation block

**Balance Calculation Explained:**
```
Starting: 250.00000000 BTC
Send:     -5.00000000 BTC
Fee:      -0.00001410 BTC (transaction fee)
Reward:   +50.00000000 BTC (mining confirmation block)
Final:    296.99998590 BTC
```

**Key features:**
- Automatic balance validation
- Real Bitcoin transaction with valid transaction ID
- Automatic confirmation mining
- Comprehensive before/after reporting
- **Repeatable**: Each run creates a new transaction

### 5. Complete Workflow Demo

**Purpose**: Demonstrate the entire system working together.

```bash
# Run complete demonstration
make demo

# This executes:
# 1. Start containers (make up)
# 2. Connect nodes together
# 3. Mining 101 blocks (generates 250+ BTC)
# 4. Transaction 1: 5.0 BTC from node1 to node2
# 5. Transaction 2: 2.5 BTC from node2 to node1
# 6. Final status report
```

## All Available Make Commands

**Container Management:**
```bash
make up      # Start Bitcoin containers (with 10s wait)
make status  # Show container status
make logs    # View container logs
make test    # Test RPC connectivity to both nodes
make stop    # Stop containers (keeps data)
make clean   # Remove containers
make purge   # Remove everything (containers, volumes, images)
```

**Bitcoin Operations:**
```bash
make setup   # Connect nodes together
make mine    # Mine 101 blocks
make send    # Send 5.0 BTC from node1 to node2
make demo    # Run complete workflow demonstration
```

## System Capabilities

**Multi-run Support**: Each transaction script execution creates a new transaction
**Automatic Wallet Management**: Wallets created and managed transparently  
**Error Handling**: Comprehensive validation and error reporting
**Real Bitcoin Operations**: Uses actual Bitcoin Core RPC calls
**Fast Testing**: Regtest mode for instant mining and low fees
**Clean Scripts**: Simple, readable bash scripts
**Docker Isolation**: Containerized environment for consistency

## Technical Implementation

- **Bitcoin Core 28.1** running in Ubuntu 22.04 containers
- **Regtest network** for private blockchain testing
- **Docker Compose** orchestration for multi-node setup
- **RPC API** integration for all Bitcoin operations
- **Wallet-specific calls** for proper Bitcoin Core interaction
- **Automatic confirmation** mining for transaction completion

## Development Approach

This project demonstrates good Git hygiene:
- **Multiple focused commits** with descriptive messages
- **Incremental development** with working features at each step
- **Comprehensive testing** of all functionality
- **Clean code structure** with reusable components

## Quick Command Summary

**Complete workflow in one sequence:**

Run the entire Bitcoin regtest demonstration from start to finish:

**Step 1: Start Containers**
```bash
make up
```

**Step 2: Connect Nodes**
```bash
make setup
```

**Step 3: Mine Blocks**
```bash
make mine
```

**Step 4: Send Transaction**
```bash
make send
```

**Step 5: Check Status**
```bash
make status
```

**Step 6: Clean Up**
```bash
make clean
```