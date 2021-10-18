FROM matterlabs/llvm_runner:latest as builder 
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker/.ssh
RUN --mount=type=secret,id=ssh_key cp /run/secrets/ssh_key /home/docker/.ssh/id_rsa 

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN chown -R docker:docker /home/docker/.ssh
RUN chown -R docker:docker /usr/local/cargo

USER docker 

WORKDIR /home/docker/

RUN git clone --depth 1 --branch main git@github.com:matter-labs/compiler-llvm.git        

WORKDIR ./compiler-llvm

ENV DIRECTORY_SUFFIX='release'
ENV BUILD_TYPE='Release'
ENV LLVM_VERSION=13
RUN cmake \
            -S 'llvm' \
            -B "../build-${DIRECTORY_SUFFIX}/" \
            -G 'Unix Makefiles' \
            -DCMAKE_INSTALL_PREFIX="${HOME}/opt/llvm-${DIRECTORY_SUFFIX}/" \
            -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
            -DCMAKE_C_COMPILER="clang-${LLVM_VERSION}" \
            -DCMAKE_CXX_COMPILER="clang++-${LLVM_VERSION}" \
            -DLLVM_TARGETS_TO_BUILD='X86' \
            -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='SyncVM' \
            -DLLVM_OPTIMIZED_TABLEGEN='On' \
            -DLLVM_USE_LINKER="lld-${LLVM_VERSION}" \
            -DLLVM_BUILD_DOCS='Off' \
            -DLLVM_INCLUDE_DOCS='Off' \
            -DLLVM_ENABLE_DOXYGEN='Off' \
            -DLLVM_ENABLE_SPHINX='Off' \
            -DLLVM_ENABLE_OCAMLDOC='Off' \
            -DLLVM_ENABLE_BINDINGS='Off' \
            && cd ../build-${DIRECTORY_SUFFIX}/ \
            && make -j "$(nproc)" \
            && make install

WORKDIR /home/docker/


RUN git clone --depth 1 --branch main git@github.com:matter-labs/compiler-yul.git

WORKDIR compiler-yul
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN ./run.sh

FROM debian:buster-slim

RUN apt-get --yes update
RUN apt-get install --yes software-properties-common ca-certificates gnupg
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1C52189C923F6CA9


RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get --yes update
RUN apt-get install solc

COPY --from=builder /home/docker/compiler-yul/target/release/yulc /usr/local/bin/
COPY compile.sh .
CMD ["./compile.sh"]

