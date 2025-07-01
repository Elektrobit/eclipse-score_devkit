#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"

devcontainer build --workspace-folder src/${IMAGE} --push true --image-name ghcr.io/elektrobit/eclipse-score_devkit:latest
