FROM matterlabs/llvm_runner:latest as builder
WORKDIR /home/docker/

# Obtain `vyper` 0.3.3.
RUN wget https://github.com/vyperlang/vyper/releases/download/v0.3.3/vyper.0.3.3+commit.48e326f0.linux \
    && mv vyper.0.3.3+commit.48e326f0.linux vyper \
    && chmod +x vyper

FROM ubuntu:22.04

COPY ./zkvyper-linux-amd64-musl /usr/local/bin/zkvyper
COPY --from=builder /home/docker/vyper /usr/local/bin/
CMD ["zkvyper"]
