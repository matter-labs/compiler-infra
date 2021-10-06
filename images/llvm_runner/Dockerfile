FROM debian:buster-slim

WORKDIR /usr/src/zksync

# Install required dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        bash git openssl curl libssl-dev sudo ssh-client \
        cmake gcc g++ \
        libpq-dev pkg-config \
        software-properties-common jq \
        libncurses5 xz-utils wget  && \
    rm -rf /var/lib/apt/lists/* 

# Install Rust and required cargo packages
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN apt-get update && apt-get install -y gnupg

#Getting prebuilt binary from llvm
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-13 main"
RUN apt-get --yes update
RUN apt-get --yes install cmake clang-13 lld-13

ENV PATH=/usr/local/clang_13/bin:$PATH \
    D_LIBRARY_PATH=/usr/local/clang_13/lib:$LD_LIBRARY_PATH’

CMD [ “tail -f /dev/null” ]
