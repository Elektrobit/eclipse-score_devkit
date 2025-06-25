#!/usr/bin/env bash
set -euo pipefail

# "Common" tools
apt-get update
apt-get install -y \
    curl

# GraphViz
apt-get install -y graphviz

# Bazel, via APT
# - ghcr.io/devcontainers-community/features/bazel uses bazelisk, which has a few problems:
#   - It does not install bash autocompletion
#   - The bazel version is not pinned (which is required to be reproducible and to have coordinated, tested tool updates).
#   - In general, pre-built containers *shall not* download "more tools" from the internet.
#     This is an operational risk (security, availability); it makes the build non-reproducible,
#     and it prevents the container from working in air-gapped environments.
apt-get install apt-transport-https curl gnupg -y
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel-archive-keyring.gpg
mv bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
apt-get update

# Buildifier, directly from GitHub (apparently no APT package available)
apt-get install -y bazel=${BAZEL_VERSION}
curl -L "https://github.com/bazelbuild/buildtools/releases/download/v${BUILDIFIER_VERSION}/buildifier-linux-amd64" -o /usr/local/bin/buildifier
chmod +x /usr/local/bin/buildifier

# Code completion for C++ code of Bazel projects
# see https://github.com/kiron1/bazel-compile-commands
source /etc/lsb-release
curl -L "https://github.com/kiron1/bazel-compile-commands/releases/download/v${BAZEL_COMPILE_COMMANDS_VERSION}/bazel-compile-commands_${BAZEL_COMPILE_COMMANDS_VERSION}-${DISTRIB_CODENAME}_amd64.deb" -o bazel-compile-commands.deb
dpkg -i bazel-compile-commands.deb
rm  bazel-compile-commands.deb

# Cleanup
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
