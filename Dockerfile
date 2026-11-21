FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    ANSIBLE_COLLECTIONS_PATH=/opt/ansible/collections \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --break-system-packages \
        ansible \
        ansible-lint \
        proxmoxer \
        requests \
    && mkdir -p /opt/ansible/collections \
    && ansible-galaxy collection install community.proxmox -p /opt/ansible/collections

WORKDIR /lab


