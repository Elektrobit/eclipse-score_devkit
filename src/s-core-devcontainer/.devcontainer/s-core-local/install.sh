#!/usr/bin/env bash
set -euo pipefail

# Copy feature sources and tests to expected location
FEATURES_DIR="/devcontainer/features"
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname -- "${SCRIPT_PATH}")
mkdir -p "${FEATURES_DIR}"
COPY_TARGET="${FEATURES_DIR}/$(basename "${SCRIPT_DIR%%_*}")"
cp -R "${SCRIPT_DIR}" "${COPY_TARGET}"
rm -f "${COPY_TARGET}/devcontainer-features.env" "${COPY_TARGET}/devcontainer-features-install.sh"

# Check variables
if [ -z "${BAZEL_VERSION:-}" ]; then
    echo "Error: BAZEL_VERSION is not set."
    exit 1
fi
if [ -z "${BUILDIFIER_VERSION:-}" ]; then
    echo "Error: BUILDIFIER_VERSION is not set."
    exit 1
fi
if [ -z "${BUILDIFIER_SHA256:-}" ]; then
    echo "Error: BUILDIFIER_SHA256 is not set."
    exit 1
fi
if [ -z "${BAZEL_COMPILE_COMMANDS_VERSION:-}" ]; then
    echo "Error: BAZEL_COMPILE_COMMANDS_VERSION is not set."
    exit 1
fi
if [ -z "${BAZEL_COMPILE_COMMANDS_SHA256:-}" ]; then
    echo "Error: BAZEL_COMPILE_COMMANDS_SHA256 is not set."
    exit 1
fi

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
apt-get install -y bazel=${BAZEL_VERSION}

# Buildifier, directly from GitHub (apparently no APT package available)
curl -L "https://github.com/bazelbuild/buildtools/releases/download/v${BUILDIFIER_VERSION}/buildifier-linux-amd64" -o /usr/local/bin/buildifier
echo "${BUILDIFIER_SHA256} /usr/local/bin/buildifier" | sha256sum -c - || exit -1
chmod +x /usr/local/bin/buildifier

# Code completion for C++ code of Bazel projects
# see https://github.com/kiron1/bazel-compile-commands
source /etc/lsb-release
curl -L "https://github.com/kiron1/bazel-compile-commands/releases/download/v${BAZEL_COMPILE_COMMANDS_VERSION}/bazel-compile-commands_${BAZEL_COMPILE_COMMANDS_VERSION}-${DISTRIB_CODENAME}_amd64.deb" -o bazel-compile-commands.deb
# Extract correct sha256 for current DISTRIB_CODENAME and check
BAZEL_COMPILE_COMMANDS_DEB_SHA256=$(echo "${BAZEL_COMPILE_COMMANDS_SHA256}" | tr ';' '\n' | grep "^${DISTRIB_CODENAME}:" | cut -d: -f2)
echo "$BAZEL_COMPILE_COMMANDS_DEB_SHA256"
echo "${BAZEL_COMPILE_COMMANDS_DEB_SHA256} bazel-compile-commands.deb" | sha256sum -c - || exit -1

dpkg -i bazel-compile-commands.deb
rm  bazel-compile-commands.deb

# Cleanup
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
