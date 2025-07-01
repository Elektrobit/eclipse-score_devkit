#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"

devcontainer build --workspace-folder src/${IMAGE}
