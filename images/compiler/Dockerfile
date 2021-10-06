FROM matterlabs/llvm_runner:latest
RUN apt-get update && apt-get install -y openssh-client git sudo 
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN mkdir -p /home/docker/.ssh
COPY id_rsa /home/docker/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN chown -R docker:docker /home/docker/.ssh
USER docker 
WORKDIR /home/docker/

RUN git clone --depth 1 --branch deniallugo_change_clang  git@github.com:matter-labs/compiler-llvm.git        

ENV DIRECTORY_SUFFIX='release'
ENV BUILD_TYPE='Release'
ENV LLVM_VERSION=13

user root

RUN apt install build-essential -y
WORKDIR ./compiler-llvm

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
            -DLLVM_ENABLE_BINDINGS='Off'
