FROM matterlabs/llvm_runner:latest as builder 
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker/.ssh
RUN --mount=type=secret,id=ssh_key cp /run/secrets/ssh_key /home/docker/.ssh/id_rsa 

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN chown -R docker:docker /home/docker/.ssh
RUN chown -R docker:docker /usr/local/cargo

USER docker 

WORKDIR /home/docker/

RUN git clone --depth 1 --branch main git@github.com:matter-labs/compiler-llvm.git \
    && cd compiler-llvm \
    && ./build.sh release

WORKDIR /home/docker/


RUN git clone --depth 1 --branch main git@github.com:matter-labs/compiler-yul.git

WORKDIR compiler-yul

RUN ./run.sh

FROM debian:bullseye-slim

RUN apt-get --yes update
RUN apt-get install --yes software-properties-common ca-certificates gnupg
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1C52189C923F6CA9


RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get --yes update
RUN apt-get install solc

COPY --from=builder /home/docker/compiler-yul/target/release/yulc /usr/local/bin/
COPY compile.sh .
CMD ["./compile.sh"]
