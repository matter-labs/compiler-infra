FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    bash git openssl curl libssl-dev sudo ssh-client \
    cmake gcc-9 g++-9 ninja-build \
    libpq-dev pkg-config \
    software-properties-common jq \
    openssh-client git \
    build-essential \
    libncurses5 xz-utils wget gnupg musl-tools valgrind && \
    rm -rf /var/lib/apt/lists/*

# Set gcc-9 as default for old compiler builds
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    update-alternatives --config gcc && \
    gcc --version

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - && \
    apt-add-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-15 main" && \
    apt-get --yes update && \
    apt-get --yes install cmake clang-15 lld-15 clang-tidy-15

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get --yes install python3.12 python3.12-dev python3.12-distutils

# Required to build solidity fork
RUN apt-get update && apt-get -y install -y \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-test-dev \
    libboost-system-dev \
    libboost-program-options-dev \
    libcvc4-dev \
    libcln-dev \
    libboost-regex-dev \
    libboost-thread-dev \
    libboost-random-dev

ENV PATH=/usr/lib/llvm-15/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib/llvm-15/lib:$LD_LIBRARY_PATH \
    LLVM_VERSION=15 \
    CI_RUNNING=true
