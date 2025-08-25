# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Fix GPG signature issues and update package list
RUN apt-get update --allow-insecure-repositories || true \
    && apt-get install -y --allow-unauthenticated \
        ca-certificates \
        gnupg \
        wget \
        curl \
    && apt-get update \
    && apt-get install -y \
        software-properties-common \
        build-essential \
        git \
        ninja-build \
        python3 \
        python3-pip \
        lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install GCC-14 (available in Ubuntu 24.04 standard repos)
RUN apt-get update && \
    apt-get install -y \
    gcc-14 \
    g++-14 \
    && rm -rf /var/lib/apt/lists/*

# Set GCC-14 as default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 100

# Install CMake 3.30+ (latest stable version which meets the 4.0 requirement)
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | \
    tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

# Install LLVM/Clang 19 (latest available in Ubuntu 24.04 standard repos)
RUN apt-get update && \
    apt-get install -y \
    clang-19 \
    clang++-19 \
    clang-tools-19 \
    clang-tidy-19 \
    clang-format-19 \
    clangd-19 \
    libc++-19-dev \
    libc++abi-19-dev \
    lld-19 \
    lldb-19 \
    && rm -rf /var/lib/apt/lists/*

# Set Clang-19 as alternatives
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-19 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-19 100 && \
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-19 100

# Install additional useful development tools
RUN apt-get update && apt-get install -y \
    gdb \
    valgrind \
    cppcheck \
    doxygen \
    graphviz \
    ccache \
    pkg-config \
    make \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for development
RUN groupadd -r developer && useradd -r -g developer -m -s /bin/bash developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set working directory
WORKDIR /workspace

# Change ownership of workspace to developer user
RUN chown -R developer:developer /workspace

# Switch to developer user
USER developer

# Set up shell environment
RUN echo 'export CC=gcc-14' >> ~/.bashrc && \
    echo 'export CXX=g++-14' >> ~/.bashrc && \
    echo 'export PATH=/usr/lib/llvm-19/bin:$PATH' >> ~/.bashrc

# Verify installations by creating a simple test script
RUN echo '#!/bin/bash' > /tmp/verify_tools.sh && \
    echo 'echo "=== Tool Versions ==="' >> /tmp/verify_tools.sh && \
    echo 'gcc --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'g++ --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'cmake --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'clang --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'clang++ --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'clang-tidy --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'clang-format --version | head -1' >> /tmp/verify_tools.sh && \
    echo 'clangd --version | head -1' >> /tmp/verify_tools.sh && \
    chmod +x /tmp/verify_tools.sh

# Default command
CMD ["/bin/bash"]
