FROM debian:buster-slim

WORKDIR /usr/src/zksync

# Install required dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        bash git openssl curl libssl-dev sudo ssh-client \
        cmake gcc g++ \
        libpq-dev pkg-config \
        software-properties-common jq \
        libncurses5 xz-utils && \
    rm -rf /var/lib/apt/lists/* 

# Install Rust and required cargo packages
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

#Getting prebuilt binary from llvm
ENV CLANG_ARCHIVE_LINK="https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0-rc1/clang+llvm-13.0.0-rc1-powerpc64le-linux-ubuntu-18.04.tar.xz"
RUN curl -SL ${CLANG_ARCHIVE_LINK} | tar -xJC . && \
    mv clang+llvm-13.0.0-rc1-powerpc64le-linux-ubuntu-18.04 /usr/local/clang_13
ENV PATH=/usr/local/clang_13/bin:$PATH \
    D_LIBRARY_PATH=/usr/local/clang_13/lib:$LD_LIBRARY_PATH’

CMD [ “tail -f /dev/null” ]
