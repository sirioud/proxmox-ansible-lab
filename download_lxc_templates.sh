#!/usr/bin/env bash
set -euo pipefail

# Download latest standard Debian 13 & Ubuntu 24.04 templates to 'local' storage
echo "=== Updating Proxmox appliance template catalog ==="
pveam update

echo "=== Downloading Ubuntu 24.04 standard template to local storage ==="
pveam download local ubuntu-24.04-standard_24.04-2_amd64.tar.zst || true

echo "=== Templates currently available on local storage: ==="
pveam list local
