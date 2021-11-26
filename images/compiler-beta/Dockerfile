FROM matterlabs/llvm_runner:latest as builder 
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker/.ssh
RUN --mount=type=secret,id=ssh_key cp /run/secrets/ssh_key /home/docker/.ssh/id_rsa 

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN chown -R docker:docker /home/docker/.ssh
RUN chown -R docker:docker /usr/local/cargo

USER docker 

WORKDIR /home/docker/

# Obtain `solc` 0.8.10.
RUN wget https://github.com/ethereum/solc-bin/raw/gh-pages/linux-amd64/solc-linux-amd64-v0.8.10%2Bcommit.fc410830 \
    && mv solc-linux-amd64-v0.8.10+commit.fc410830 solc \
    && chmod +x solc

# Download LLVM and build it.
RUN git clone --depth 1 --branch main git@github.com:matter-labs/compiler-llvm.git

# TODO: We can't use `./build.sh release`, since it has `sudo` command which fails.
#       Currently it's a copy-paste from `./build.sh` with `sudo make install` replaced by `make install`.
WORKDIR /home/docker/compiler-llvm
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

# Download zksolc and build it.
WORKDIR /home/docker/
RUN git clone --depth 1 --branch main git@github.com:matter-labs/compiler-solidity.git \
    && cd compiler-solidity \
    && ./run.sh info release


FROM debian:buster-slim

COPY --from=builder /home/docker/compiler-solidity/target/release/zksolc /usr/local/bin/
COPY --from=builder /home/docker/solc /usr/local/bin/
CMD ["zksolc"]
