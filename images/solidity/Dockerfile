FROM matterlabs/llvm_runner:latest as builder
WORKDIR /home/docker/

# Obtain `solc`.
RUN wget https://github.com/ethereum/solidity/releases/download/$SOLC_VERSION/solc-static-linux \
    && mv solc-static-linux solc \
    && chmod +x solc

FROM ubuntu:22.04

COPY ./zksolc-linux-amd64-musl /usr/local/bin/zksolc
COPY --from=builder /home/docker/solc /usr/local/bin/
CMD ["zksolc"]
