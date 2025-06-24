#!/bin/bash
set -eo pipefail

devcontainer build --workspace-folder src/s-core-devcontainer --push true --image-name ghcr.io/elektrobit/s-core-devcontainer:latest