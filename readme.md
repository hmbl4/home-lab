# Home Lab Security Automation

This project sets out to provision a secure cloud-based environment using **Terraform** and automate the installation of key **security tools** with **Ansible**. The goal is to simulate a real-world deployment of IDS/IPS and SIEM components, allowing experimentation and learning in a reproducible and modular way.

## What This Project Achieves

- Infrastructure provisioning on AWS with public/private VPCs  
- Deployment of a Ubuntu EC2 instance with tight security groups  
- Automated installation of:
  - Suricata – Network-based IDS/IPS  
  - Wazuh Agent – Host-based SIEM  
  - Optional tools like fail2ban, osquery, and logstash  
- System hardening via Ansible tasks  

## Quick Start Instructions

Clone the repo and run the playbooks:

### Run Suricata playbook
ansible-playbook -i ansible/inventory.ini ansible/playbook-suricata.yml

### Run Wazuh Agent playbook
ansible-playbook -i ansible/inventory.ini ansible/playbook-wazuh-agent.yml

### Run Fail2Ban playbook (optional)
ansible-playbook -i ansible/inventory.ini ansible/playbook-fail2ban.yml


## AWS Infrastructure (Provision with Terraform)

- VPC:  
  - Public and private subnets  

- Security Groups:  
  - Allow SSH (port 22) only from your IP  
  - Allow HTTP (port 80) and ports for Suricata/Wazuh as needed  

- EC2:  
  - 1x Ubuntu instance (t2.micro, Free Tier eligible) in the public subnet  
  - SSH access using a key pair  

- Optional:  
  - S3 bucket for log storage or threat intel feeds  

## Ansible Setup for Security Tooling

Inside the `ansible/` directory:

### Files:
- `inventory.ini` — Define the target hosts  
- `playbook-suricata.yml` — Installs and configures Suricata  
- `playbook-wazuh-agent.yml` — Installs and configures Wazuh Agent  
- `playbook-fail2ban.yml` — Optional, installs fail2ban  

### Tasks Performed:
- Update system packages  
- Install and configure security tools  
- Enable services and logging  
- Basic instance hardening:  
  - Disable root login  
  - Enable UFW (firewall)  

## Suggested Repo Structure

```
home-lab/
├── terraform/
│ ├── main.tf
│ └── variables.tf
├── ansible/
│ ├── inventory.ini
│ ├── playbook-suricata.yml
│ ├── playbook-wazuh-agent.yml
│ └── playbook-fail2ban.yml
└── README.md
```

Include:  
- Documentation on running Terraform and Ansible  
- Notes on tool usage, configuration, and decisions  

## Reference

Inspired by Spacelift's Terraform Tutorial:  
https://spacelift.io/blog/terraform-tutorial