#!/usr/bin/env bash
set -euo pipefail

check "validate bazel is working and has the correct version" bash -c "bazel version | grep 'Build label: 7.5.0'"
check "validate bazel-compile-commands is working and has the correct version" bash -c "bazel-compile-commands --version 2>&1| grep 'bazel-compile-commands: 0.17.2'"
check "validate buildifier is working and has the correct version" bash -c "buildifier --version | grep 'buildifier version: 8.2.1'"
check "validate git is working" bash -c "git --version"
