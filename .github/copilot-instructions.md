# C++ Template Development Environment

This repository provides a modern C++ development environment template with Docker-based tooling for cross-platform development.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Bootstrap and Build the Development Environment
**CRITICAL - Use proper timeouts for all Docker operations:**

1. **Build Docker image** - NEVER CANCEL. Takes ~90 seconds. Set timeout to 180+ seconds:
   ```bash
   docker build -t cpp-template .
   ```

2. **Verify tools installation**:
   ```bash
   docker run --rm cpp-template /tmp/verify_tools.sh
   ```
   Expected output shows versions of GCC-14, Clang-19, CMake 4.1+, and all LLVM tools.

### Development Environment Options

#### Option 1: VS Code Dev Container (Recommended for Interactive Development)
```bash
# Prerequisites: VS Code + Dev Containers extension
# Open project in VS Code, then:
# Ctrl+Shift+P → "Dev Containers: Reopen in Container"
```
- Automatically builds Docker image and sets up environment
- Pre-configured C++ extensions, IntelliSense with clangd
- Integrated debugging with GDB/LLDB, CMake integration

#### Option 2: Docker Compose (Recommended for CLI Development)
```bash
# Start development container - takes ~5 seconds:
docker compose up -d

# Access container shell:
docker compose exec cpp-dev bash

# Stop when done:
docker compose down
```

#### Option 3: Manual Docker Usage
```bash
# Run interactively:
docker run -it --rm -v $(pwd):/workspace cpp-template

# Run with persistent build cache:
docker run -it --rm -v $(pwd):/workspace -v cpp-build-cache:/workspace/build cpp-template
```

## Validation and Development Workflow

### Always validate changes with these steps:

1. **Create a test C++ project**:
   ```bash
   # Inside container as developer user:
   cd /tmp
   mkdir test-project && cd test-project
   
   # Create simple test file:
   cat > main.cpp << 'EOF'
   #include <iostream>
   int main() {
       std::cout << "Hello, World!" << std::endl;
       return 0;
   }
   EOF
   ```

2. **Test GCC compilation**:
   ```bash
   g++ -o hello main.cpp && ./hello
   # Expected output: Hello, World!
   ```

3. **Test Clang compilation**:
   ```bash
   clang++ -o hello-clang main.cpp && ./hello-clang
   # Expected output: Hello, World!
   ```

4. **Test CMake build system**:
   ```bash
   # Create CMakeLists.txt:
   cat > CMakeLists.txt << 'EOF'
   cmake_minimum_required(VERSION 3.20)
   project(TestProject)
   
   set(CMAKE_CXX_STANDARD 23)
   set(CMAKE_CXX_STANDARD_REQUIRED ON)
   
   add_executable(hello main.cpp)
   EOF
   
   # Configure and build:
   cmake -B build -G Ninja .
   cmake --build build
   ./build/hello
   # Expected output: Hello, World!
   ```

5. **Test code formatting and analysis**:
   ```bash
   # Format code:
   clang-format main.cpp
   
   # Static analysis:
   clang-tidy main.cpp --
   ```

### Critical Timing and Timeout Information

**NEVER CANCEL these operations - they are normal:**
- **Docker build**: ~90 seconds (set timeout to 180+ seconds)
- **Docker Compose startup**: ~5 seconds (set timeout to 30+ seconds)
- **CMake configuration**: ~1 second for simple projects
- **CMake build**: <1 second for simple projects
- **Tool verification**: <1 second

## Available Tools and Versions

The development environment includes:

### Compilers
- **GCC-14**: Primary C++ compiler with C++23 support
- **Clang-19**: Alternative compiler with advanced diagnostics
- **CMake 4.1.0**: Build system (full CMake 4.0+ support)

### Development Tools
- **Ninja**: Fast build system generator
- **clang-format-19**: Code formatting
- **clang-tidy-19**: Static analysis and linting
- **clangd-19**: Language server for IntelliSense
- **GDB**: Debugger
- **Valgrind**: Memory debugging
- **cppcheck**: Additional static analysis
- **doxygen**: Documentation generation

### Environment Variables (Auto-configured)
- `CC=gcc-14`
- `CXX=g++-14`
- `PATH` includes `/usr/lib/llvm-19/bin`

## Common Project Setup Patterns

### For new C++ projects using this template:

1. **Create basic CMake project structure**:
   ```bash
   mkdir src include tests
   # Add your CMakeLists.txt, source files, headers
   ```

2. **Use recommended build directory**:
   ```bash
   cmake -B build -G Ninja
   cmake --build build
   ```

3. **Always run formatting before committing**:
   ```bash
   find src include -name "*.cpp" -o -name "*.hpp" | xargs clang-format -i
   ```

4. **Run static analysis**:
   ```bash
   find src -name "*.cpp" | xargs clang-tidy
   ```

## Troubleshooting

### If Docker build fails:
- Ensure you're using standard Ubuntu repositories (no PPAs required)
- Check internet connectivity for package downloads
- NEVER CANCEL - builds may take up to 90 seconds

### If tools are missing:
- Run `/tmp/verify_tools.sh` to check installed versions
- Rebuild Docker image if tools are outdated

### If file permissions are wrong:
- The container runs as `developer` user (non-root)
- Workspace directory `/workspace` is owned by `developer`
- Use `--user developer` flag for manual Docker runs

## Repository Structure Reference

```
.
├── README.md                    # Project documentation
├── Dockerfile                   # Development environment definition  
├── docker-compose.yml           # Container orchestration
├── .devcontainer/              
│   └── devcontainer.json       # VS Code dev container config
├── .clangd                     # Clangd language server settings
└── .dockerignore               # Docker build exclusions
```

## Notes for Code Changes

- This is a **template repository** - no actual C++ source code included
- The Docker environment supports C++23 standard
- All modern LLVM tools are pre-configured and working
- Build cache is persistent via Docker volumes
- VS Code extensions are pre-installed and configured in dev container mode