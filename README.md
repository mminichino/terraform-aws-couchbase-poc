<!--
:type: service
:name: Couchbase
:description: Deploy a POC Couchbase cluster.
:icon: /docs/couchbase_logo.png
:category: other-data-stores
:cloud: aws
:tags: nosql
:license: open-source
:built-with: terraform, bash
-->

# terraform-aws-couchbase-poc

Utilities for deploying a Couchbase environment for testing.

## Easy Install
You can run a container with all the lab automation utilities preloaded. It has its own isolated DNS server that allows dynamic updates. All that is needed is a system with Docker (that is not running another DNS server).

Prerequisite - copy needed SSH keys to the system with docker if needed. Keys are used to access created systems and for automation.
````
scp .ssh/*.pem 172.48.5.55:/home/admin/.ssh
````
1. Get control utility
````
curl https://github.com/mminichino/perfctl-container/releases/latest/download/run-perfctl.sh -L -O
````
````
chmod +x run-perfctl.sh
````
2. Run container
````
./run-perfctl.sh --run
````
3. Login to running container
````
./run-perfctl.sh --shell
````
4. Setup DNS
````
./install.sh
````
````
 1) ens192: 172.48.5.55
 2) docker0: 172.17.0.1
Interface for DNS zone: 1
server reload successful
````
5. Use provided utilities. You may wish to run ````git pull```` in all the project directories to make sure you have all the latest updates.
````
bin/make-aws-creds.sh
````
````
refresh_aws_key -a arn:aws:iam::1234567890:mfa/john.doe@domain.com -t 123456
````
````
. load-aws-env.sh
````
````
cd terraform-aws-couchbase-poc
````
````
scripts/load_variables.sh
````
````
terraform init
````
````
terraform apply
````

## Manual Setup
### Prerequisites:
Environment:
* DNS server with domain that allows TSIG dynamic updates
* AWS API access key and secret key

Python packages (install with ````pip3````):
* boto
* boto3
* botocore
* dnspython
* netaddr

Linux packages (install with ````yum```` or ````dnf```` or ````apt````):
* ansible
* terraform

Ansible Galaxy Collections:
* community.general
* ansible.netcommon

### Setup:
1. Install prerequisites
2. Install AWS CLI if no already installed
````
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
````
### Quick Start:
````
$ git clone https://github.com/mminichino/perf-lab-bin
$ git clone https://github.com/mminichino/couchbase-init
$ git clone https://github.com/mminichino/terraform-aws-couchbase-poc
$ git clone https://github.com/mminichino/db-host-prep
$ git clone https://github.com/mminichino/ansible-helper
$ export HELPER_PATH=/home/admin/db-host-prep/playbooks:/home/admin/couchbase-init/playbooks
$ perf-lab-bin/set-dns-key.sh
$ cd terraform-aws-couchbase-poc
$ scripts/load_variables.sh
$ terraform init
$ terraform apply
$ bin/run_bench_cb.sh cbnode-01-ded10da4.domain.com
````
