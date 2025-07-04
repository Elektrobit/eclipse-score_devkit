#!/bin/bash
set -euo pipefail

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname -- "${SCRIPT_PATH}")
source "${SCRIPT_DIR}/../../../scripts/test-utils.sh" vscode

# Tests from the local s-core-local feature
source /devcontainer/features/s-core-local/tests/test_default.sh

# Report result
reportResults
