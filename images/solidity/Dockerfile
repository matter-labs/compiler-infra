FROM matterlabs/llvm_runner:latest as builder
WORKDIR /home/docker/

# Obtain `solc`.
RUN wget https://github.com/ethereum/solidity/releases/download/$SOLC_VERSION/solc-static-linux \
    && mv solc-static-linux solc \
    && chmod +x solc

FROM ubuntu:20.04

COPY ./zksolc /usr/local/bin/
COPY --from=builder /home/docker/solc /usr/local/bin/
CMD ["zksolc"]
