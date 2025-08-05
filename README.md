# Bitcoin Regtest Network with Docker

A Docker-based setup for running a private Bitcoin regtest network with at least 2 nodes, paired together for block mining and transaction processing.

## Overview

This system implements the following requirements:
- Launch a private Bitcoin Network (regtest) with at least 2 nodes using Docker and bash
- Pair nodes between each other
- Mine blocks on the network
- Send transactions from one node to another
- Provide well-documented examples of mining blocks and sending transactions
- Support multiple runs with new transactions each time

## Project Structure

```
bitcoin-core/
├── README.md                 # This file
├── docker/
│   ├── Dockerfile           # Bitcoin Core container
│   └── docker-compose.yml   # Multi-node orchestration
├── scripts/
│   ├── setup-network.sh     # Main network setup script
│   ├── mine-blocks.sh       # Block mining utilities
│   ├── send-transaction.sh  # Transaction creation and broadcast
│   └── utils.sh             # Helper functions
├── config/
│   ├── bitcoin1.conf        # Node 1 configuration
│   └── bitcoin2.conf        # Node 2 configuration
└── docs/
    └── examples.md           # Usage examples and documentation
```

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd bitcoin-core

# Start the Bitcoin regtest network
./scripts/setup-network.sh

# Mine some blocks
./scripts/mine-blocks.sh 101

# Send a transaction
./scripts/send-transaction.sh <from_node> <to_address> <amount>
```

## Requirements

- Docker and Docker Compose
- Bash (Unix/Linux environment)
- Git

## Features

- Private Bitcoin regtest network with 2+ nodes
- Automated node pairing and connection
- Block mining functionality
- Transaction creation and broadcasting between nodes
- Repeatable script execution (creates new transactions each run)
- Well-documented examples and usage instructions