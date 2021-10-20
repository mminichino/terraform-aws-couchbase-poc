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