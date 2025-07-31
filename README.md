# C++ template project

This repo contains a template for C++ project that can be used both
from popular IDEs and the command line.

## Features

- Docker development environment with:
  - GCC-15 for C++ compilation
  - CMake 3.30+ (meets CMake 4.0 requirement)
  - Clang-21 with full toolchain:
    - clang-tidy for static analysis
    - clang-format for code formatting
    - clangd for language server support
  - Additional development tools (GDB, Valgrind, etc.)
- VS Code Dev Container support for seamless IDE integration

## Development Environment Setup

### Option 1: VS Code Dev Container (Recommended)

This is the easiest way to get started with a consistent development environment:

1. Install VS Code and the "Dev Containers" extension
2. Open this project in VS Code
3. When prompted, click "Reopen in Container" or use `Ctrl+Shift+P` and select "Dev Containers: Reopen in Container"
4. VS Code will automatically build the Docker image and set up the development environment

The dev container includes:
- Pre-configured C++ extensions and settings
- IntelliSense with clangd
- Integrated debugging with GDB/LLDB
- CMake integration
- Code formatting and linting tools

### Option 2: Docker Usage

### Building the Docker image

```bash
docker build -t cpp-template .
```

### Using with Docker Compose (recommended)

```bash
# Start the development container
docker-compose up -d

# Access the container shell
docker-compose exec cpp-dev bash

# Stop the container
docker-compose down
```

### Manual Docker usage

```bash
# Run interactively
docker run -it --rm -v $(pwd):/workspace cpp-template

# Run with persistent build cache
docker run -it --rm -v $(pwd):/workspace -v cpp-build-cache:/workspace/build cpp-template
```

### Verify tools installation

Once inside the container, you can verify all tools are installed correctly:

```bash
/tmp/verify_tools.sh
```

This will display the versions of all installed development tools.
