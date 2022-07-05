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

# Install Python 3.9 which is required for the compiler but not available in Debian repos
RUN apt update; \
    apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev; \
    wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz; \
    tar -zxvf Python-3.9.7.tgz; \
    cd Python-3.9.7; \
    ./configure --prefix=/usr/local/python3; \
    make && make install; \
    ln -sf /usr/local/python3/bin/python3.9 /usr/bin/python3; \
    ln -sf /usr/local/python3/bin/pip3.9 /usr/bin/pip3

ENV PATH=/usr/local/clang_13/bin:$PATH \
    D_LIBRARY_PATH=/usr/local/clang_13/lib:$LD_LIBRARY_PATH \
    LLVM_VERSION=13 \
    CI_RUNNING=true
