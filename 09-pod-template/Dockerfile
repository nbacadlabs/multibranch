# Use an Alpine Linux base image
FROM alpine:3.12

# Set environment variables to avoid interactive prompts
ENV TERRAFORM_VERSION=1.11.2 \
    KUBECTL_VERSION=v1.26.0

# Update package lists and install dependencies
RUN apk update && \
    apk add --no-cache \
    curl \
    bash \
    jq \
    sudo \
    unzip \
    py3-pip \
    python3-dev \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    cargo && \
    # Install Terraform
    curl -fsSL -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    # Install Rust and Cargo
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    # Ensure Cargo is in PATH
    export PATH="$HOME/.cargo/bin:$PATH" && \
    # Install Azure CLI
    python3 -m pip install --upgrade pip setuptools wheel && \
    pip install azure-cli && \
    # Clean up the APK cache to reduce image size
    apk del gcc musl-dev libffi-dev openssl-dev cargo python3-dev && \
    rm -rf /var/cache/apk/* terraform.zip

# Set default command
CMD ["bash"]
