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
├── README.md
├── build_ubuntu_template.sh
├── download_lxc_templates.sh
├── group_vars/
│   └── all/
│       ├── lab.yml
│       └── vault.yml
└── playbooks/
    ├── lab.yml
    ├── inspect_guest.yml
    ├── clone_vm.yml
    └── create_lxc.yml
```

## Running Playbooks

All playbooks are run via Docker Compose with automatic vault password loading:

```bash
# Smoke test
docker compose run --rm ansible-lab ansible-playbook playbooks/lab.yml

# Inspect specific guest
docker compose run --rm ansible-lab ansible-playbook playbooks/inspect_guest.yml -e target_guest_name="test-ubuntu-01"

# Provision a VM from Ubuntu 24.04 template
docker compose run --rm ansible-lab ansible-playbook playbooks/clone_vm.yml -e new_vmid=151 -e new_vm_name="my-app-01"

# Provision an LXC container
docker compose run --rm ansible-lab ansible-playbook playbooks/create_lxc.yml -e lxc_vmid=200 -e lxc_hostname="lab-ct-01"
```
