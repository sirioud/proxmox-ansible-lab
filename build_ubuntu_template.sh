#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Proxmox Ubuntu 24.04 Cloud-Init Template
# Node: karuga | Storage: local-lvm
# ==========================================

TEMPLATE_ID=9000
TEMPLATE_NAME="ubuntu-2404-cloudinit-template"
STORAGE="local-lvm"
BRIDGE="vmbr0"
IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE_FILE="/tmp/noble-server-cloudimg-amd64.img"

echo "=== [1/6] Downloading Ubuntu 24.04 cloud image ==="
if [ ! -f "$IMAGE_FILE" ]; then
    wget -q --show-progress -O "$IMAGE_FILE" "$IMAGE_URL"
else
    echo "Image already downloaded at $IMAGE_FILE"
fi

echo "=== [2/6] Destroying existing VM $TEMPLATE_ID if present ==="
qm destroy "$TEMPLATE_ID" --purge 2>/dev/null || true

echo "=== [3/6] Creating Base VM ==="
qm create "$TEMPLATE_ID" \
    --name "$TEMPLATE_NAME" \
    --memory 2048 \
    --cores 2 \
    --cpu host \
    --net0 virtio,bridge="$BRIDGE" \
    --ostype l26 \
    --agent enabled=1,fstrim_cloned_disks=1

echo "=== [4/6] Importing disk into $STORAGE ==="
qm disk import "$TEMPLATE_ID" "$IMAGE_FILE" "$STORAGE"

echo "=== [5/6] Attaching disk and Cloud-Init drive ==="
# Attach imported disk to scsi0
qm set "$TEMPLATE_ID" \
    --scsihw virtio-scsi-pci \
    --scsi0 "${STORAGE}:vm-${TEMPLATE_ID}-disk-0,discard=on,ssd=1" \
    --boot c \
    --bootdisk scsi0

# Attach Cloud-Init drive to ide2
qm set "$TEMPLATE_ID" --ide2 "${STORAGE}:cloudinit"

# Enable serial terminal for Proxmox web console
qm set "$TEMPLATE_ID" --serial0 socket --vga serial0

# Set default Cloud-Init network to DHCP
qm set "$TEMPLATE_ID" --ipconfig0 ip=dhcp

echo "=== [6/6] Converting VM to Template ==="
qm template "$TEMPLATE_ID"

echo "✅ Ubuntu 24.04 Template (ID: $TEMPLATE_ID) successfully built on karuga!"
