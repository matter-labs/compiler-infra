FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    bash git openssl curl libssl-dev sudo ssh-client \
    cmake gcc g++ ninja-build \
    libpq-dev pkg-config \
    software-properties-common jq \
    openssh-client git \
    build-essential \
    libncurses5 xz-utils wget gnupg musl-tools valgrind && \
    rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - && \
    apt-add-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main" && \
    apt-get --yes update && \
    apt-get --yes install cmake clang-15 lld-15

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get --yes install python3.10 python3.10-dev python3.10-distutils

# Required to build solidity fork
RUN apt-get update && apt-get -y install -y \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-test-dev \
    libboost-system-dev \
    libboost-program-options-dev \
    libcln-dev \
    libboost-regex-dev \
    libboost-thread-dev \
    libboost-random-dev

ENV PATH=/usr/lib/llvm-15/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib/llvm-15/lib:$LD_LIBRARY_PATH \
    LLVM_VERSION=15 \
    CI_RUNNING=true
