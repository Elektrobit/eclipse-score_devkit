#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"

devcontainer build --workspace-folder src/${IMAGE} --push false --image-name ghcr.io/elektrobit/eclipse-score_devkit:latest
