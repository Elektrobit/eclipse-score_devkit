#!/bin/bash
set -eo pipefail

devcontainer build --workspace-folder src/s-core-devcontainer --push true --image-name ghcr.io/elektrobit/eclipse-score_devkit:latest
