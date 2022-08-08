FROM matterlabs/llvm_runner:latest as builder
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker/.ssh
RUN --mount=type=secret,id=ssh_key cp /run/secrets/ssh_key /home/docker/.ssh/id_rsa 

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN chown -R docker:docker /home/docker/.ssh
RUN chown -R docker:docker /usr/local/cargo

USER docker

WORKDIR /home/docker/

# Obtain `solc` 0.8.15.
RUN wget https://github.com/ethereum/solidity/releases/download/v0.8.15/solc-static-linux \
    && mv solc-static-linux solc \
    && chmod +x solc

WORKDIR /home/docker/

# Download zksolc and build it.
RUN git config --global url."ssh://git@github.com/".insteadOf https://github.com/ \
    && git clone --branch v1.1.4 git@github.com:matter-labs/compiler-solidity.git \
    && cd compiler-solidity \
    && cargo run --release --bin llvm-builder \
    && cargo build --release

FROM ubuntu:20.04

COPY --from=builder /home/docker/compiler-solidity/target/release/zksolc /usr/local/bin/
COPY --from=builder /home/docker/solc /usr/local/bin/
CMD ["zksolc"]
