# Proxmox VE Ansible Lab

Automated Proxmox VE lab environment managed with Ansible inside a containerized development setup, using Ansible Vault (`AES256`) to protect API credentials and bind-mounted local directories (`~/Documents/Ansible` -> `/lab`) for bi-directional editing.

## Repository Structure

```text
.
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── ansible.cfg
├── inventory.ini
├── lab.yml
├── README.md
└── group_vars/
    └── all/
        ├── lab.yml
        └── vault.yml