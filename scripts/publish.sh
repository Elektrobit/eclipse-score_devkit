#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"
VERSION="${2:-latest}"

devcontainer build --workspace-folder src/${IMAGE} --push true --image-name ghcr.io/elektrobit/eclipse-score_devkit:${VERSION}
