FROM debian:buster-slim

WORKDIR /usr/src/zksync

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        bash git openssl curl libssl-dev sudo ssh-client \
        cmake gcc g++ \
        libpq-dev pkg-config \
        software-properties-common jq \
        openssh-client git \
        build-essential \
        libncurses5 xz-utils wget gnupg && \
    rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - && \
    apt-add-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-13 main" && \
    apt-get --yes update && \
    apt-get --yes install cmake clang-13 lld-13

RUN apt-get --yes install python3 python3-dev python3-distutils

ENV PATH=/usr/local/clang_13/bin:$PATH \
    D_LIBRARY_PATH=/usr/local/clang_13/lib:$LD_LIBRARY_PATH \
    LLVM_VERSION=13 \
    CI_RUNNING=true
