#!/usr/bin/env bash
set -euo pipefail

apt update
apt install -y graphviz

# Cleanup
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*