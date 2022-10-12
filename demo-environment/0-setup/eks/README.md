# Setup
This script will install a fresh Kubernetes cluster in AWS (EKS):
- EKS cluser
- a Kong gateway deployment (three nodes by default)
- a Postgres database node

# How to run the script
If you would like to run Kong inside of AWS EKS, please follow the instructions below.

Prerequesites:
- An AWS account (obviously)
- AWS CLI installed on your machine
- AWS CLI configured with a user having enough permissions
- Optional: if you are using saml2aws please append --profile saml to the eksctl command 
- eksctl installed (https://eksctl.io/)"
- kubectl installed
- Helm (version 3, not version 2!)
- yq
- jq

Steps:
- optional: edit the cluster.yaml file if you want a different region than the default one
- Run `./install.sh`

**Keep in mind that this service is cost intensive so delete it as soon as you do not need it anymore more with the also included delete.sh script**
- Run `./delete.sh` to delete your cluster
