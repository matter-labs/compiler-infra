FROM ubuntu:20.04

WORKDIR /usr/src/zksync

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    bash git openssl curl libssl-dev sudo ssh-client \
    cmake gcc g++ ninja-build \
    libpq-dev pkg-config \
    software-properties-common jq \
    openssh-client git \
    build-essential \
    libncurses5 xz-utils wget gnupg musl-tools && \
    rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - && \
    apt-add-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-13 main" && \
    apt-get --yes update && \
    apt-get --yes install cmake clang-13 lld-13

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get --yes install python3.9 python3.9-dev python3.9-distutils

# Required to build solidity fork
RUN apt-get update && apt-get -y install -y \
    libcvc4-dev \
    libcln-dev

RUN curl -L -o boost_1_81_0.tar.gz https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.gz && \
    tar xzf ./boost_1_81_0.tar.gz && \
    cd ./boost_1_81_0 && \
    ./bootstrap.sh --prefix=/usr/ && \
    ./b2 && \
    ./b2 install

ENV PATH=/usr/lib/llvm-13/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib/llvm-13/lib:$LD_LIBRARY_PATH \
    LLVM_VERSION=13 \
    CI_RUNNING=true
