# Bitcoin Core Docker Container for Regtest Network
FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Bitcoin Core version
ENV BITCOIN_VERSION=28.1

# Download and verify Bitcoin Core
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS \
    && grep "bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz" SHA256SUMS | sha256sum -c - \
    && tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && mv bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin/ \
    && rm -rf bitcoin-${BITCOIN_VERSION}* SHA256SUMS

# Create bitcoin user and directories
RUN useradd -r -s /bin/false bitcoin \
    && mkdir -p /home/bitcoin/.bitcoin \
    && chown -R bitcoin:bitcoin /home/bitcoin

# Bitcoin regtest ports
EXPOSE 18444 18443

# Set working directory
WORKDIR /home/bitcoin

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to bitcoin user
USER bitcoin

# Default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bitcoind"]