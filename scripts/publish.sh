#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-snapshot}"

devcontainer build --workspace-folder src/s-core-devcontainer --push true --image-name ghcr.io/elektrobit/eclipse-score_devkit:${VERSION}
