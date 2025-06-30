#!/usr/bin/env bash
set -euo pipefail

check "validate bazel is working and has the correct version" bash -c "bazel version"
check "validate bazel-compile-commands is working and has the correct version" bash -c "bazel-compile-commands --version"
check "validate buildifier is working and has the correct version" bash -c "buildifier --version"
check "validate git is working" bash -c "git --version"
