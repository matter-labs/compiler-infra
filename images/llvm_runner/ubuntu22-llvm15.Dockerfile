FROM ubuntu:24.04

# Use defaults from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install required apt packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    bash=5.1* \
    git=1:2.34.* \
    openssl=3.0.* \
    curl=7.81.* \
    libssl-dev=3.0.* \
    sudo=1.9.* \
    cmake=3.22.* \
    ninja-build=1.10* \
    libpq-dev=14.* \
    pkg-config=0.29* \
    jq=1.6* \
    openssh-client=1:8* \
    build-essential=12.9* \
    libncurses5=6.3* \
    xz-utils=5.2* \
    wget=1.21* \
    gnupg=2.2* \
    musl-tools=1.2* \
    valgrind=1:3.18* \
    clang-15=1:15.0.* \
    lld-15=1:15.0.* \
    clang-tidy-15=1:15.0.* \
    clang-format-15=1:15.0.* \
    libboost-dev=1.74* \
    libboost-filesystem-dev=1.74* \
    libboost-test-dev=1.74* \
    libboost-system-dev=1.74* \
    libboost-program-options-dev=1.74* \
    libboost-regex-dev=1.74* \
    libboost-thread-dev=1.74* \
    libboost-random-dev=1.74* \
    libcvc4-dev=1.8* \
    libcln-dev=1.3* \
    gcc-9=9.* \
    g++-9=9.* \
    software-properties-common=0.99.* \
    libz3-dev=4.8.* \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.11
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install --yes --no-install-recommends \
        python3.11=3.11* \
        python3.11-dev=3.11* \
        python3-distutils=3.10* \
        python3.11-venv=3.11* \
        python3-pip=22.0.* \
    && rm -rf /var/lib/apt/lists/*

# Set gcc-9 as default for old compiler builds
RUN update-alternatives --install \
    /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    update-alternatives --config gcc

# Set python3.11 as default python
RUN update-alternatives --install /usr/local/bin/python python \
    /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 \
    /usr/bin/python3.11 3

# Install Rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Set required environment variables
ENV PATH=/usr/lib/llvm-15/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/lib/llvm-15/lib:${LD_LIBRARY_PATH} \
    LLVM_VERSION=15 \
    CI_RUNNING=true
