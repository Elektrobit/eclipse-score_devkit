#!/usr/bin/env bash
set -euo pipefail

# Common tooling
check "validate git is working" bash -c "git --version"
check "validate graphviz is working" bash -c "dot -V"
check "validate curl is working" bash -c "curl --version"
check "validate protoc is working" bash -c "protoc --version"

# Bazel and related tools
check "validate bazel is working" bash -c "bazel version"
check "validate bazel-compile-commands is working" bash -c "bazel-compile-commands --version"
check "validate buildifier is working" bash -c "buildifier --version"

# C++ tooling
check "validate clang is working" bash -c "clang --version"
check "validate clangd is working" bash -c "clangd --version"
check "validate clang-format is working" bash -c "clang-format --version"
check "validate clang-tidy is working" bash -c "clang-tidy --version"

# Rust tooling
check "validate cargo is working" bash -c "cargo --version"
check "validate rustc is working" bash -c "rustc --version"
