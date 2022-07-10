FROM matterlabs/llvm_runner:latest as builder
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker/.ssh
RUN --mount=type=secret,id=ssh_key cp /run/secrets/ssh_key /home/docker/.ssh/id_rsa 

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN chown -R docker:docker /home/docker/.ssh
RUN chown -R docker:docker /usr/local/cargo

USER docker

WORKDIR /home/docker/

# Obtain `vyper` 0.3.3.
RUN wget https://github.com/vyperlang/vyper/releases/download/v0.3.3/vyper.0.3.3+commit.48e326f0.linux \
    && mv vyper.0.3.3+commit.48e326f0.linux vyper \
    && chmod +x vyper

# Download zkvyper and build it.
WORKDIR /home/docker/

RUN git clone --depth 1 --branch vm1.1 git@github.com:matter-labs/compiler-vyper.git \
    && cd compiler-vyper \
    && cargo run --release --bin llvm-builder \
    && cargo build --release

FROM ubuntu:20.04

COPY --from=builder /home/docker/compiler-vyper/target/release/zkvyper /usr/local/bin/
COPY --from=builder /home/docker/vyper /usr/local/bin/
CMD ["zkvyper"]
