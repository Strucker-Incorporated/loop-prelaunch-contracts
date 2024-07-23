# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    software-properties-common && \
    add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get install -y \
    solc \
    && rm -rf /var/lib/apt/lists/*

# Install additional tools like Foundry, Echidna, etc.
# (Add installation steps for these tools here if needed)

# Set the working directory
WORKDIR /mnt

# Default command
CMD ["bash"]
