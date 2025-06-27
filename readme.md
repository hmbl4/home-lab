## To do

### Provision below in AWS:
```VPC with public and private subnets

Security Groups:

Allow SSH (port 22) only from your IP

Allow HTTP (port 80) and Suricata/Wazuh ports as needed

EC2 instance(s):

1 x Ubuntu instance (t2.micro, Free Tier) in the public subnet

Use a key pair for SSH access

S3 Bucket (Optional):

For log storage or threat intel feeds```

### Install security tools w Ansible:
```
a. Write Ansible Playbooks
Create a separate directory ansible/ with:

inventory.ini

playbook-suricata.yml

playbook-wazuh-agent.yml (or server, depending on scope)

b. What to install:
Suricata – Network IDS/IPS

Wazuh Agent – Host-based SIEM tool

Optional: fail2ban, osquery, logstash

c. Ansible Tasks Should:
Update packages

Install security tools

Configure services (e.g., auto-start, logging)

Harden the instance (e.g., disable root login, UFW)
```

### Push All Configs to GitHub
```
a. GitHub Repo Structure Example:
arduino
Copy
Edit
home-security-lab/
├── terraform/
│   ├── main.tf
│   └── ...
├── ansible/
│   ├── inventory.ini
│   ├── playbook-suricata.yml
│   └── playbook-wazuh-agent.yml
└── README.md
b. Include:
Documentation: How to run Terraform and Ansible

Notes on tool usage

Future ideas (Phase 2+)```

