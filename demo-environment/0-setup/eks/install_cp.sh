#!/bin/bash
# . ./create_k8s_cluster.sh
. ./create_secrets_cp.sh

cp kong-cp.yaml.template kong-cp.yaml

echo -e "\n*** Installing Kong CP Enterprise"
helm install kong-hybrid-cp kong/kong -n kong-hybrid-cp --values ./kong-cp.yaml

echo -e "\n ☕ Installation done - load balancers on AWS will need a while so we'll wait now for two minutes as we need their dns entries"
sleep 120
. ./patch_addresses_cp.sh

echo -e "\n*** Loadbalancer have been created and external dns is known - we are upgrading the Helm setup now to the created addresses"
helm upgrade --install kong-hybrid-cp kong/kong -n kong-hybrid-cp --values ./kong-cp.yaml

. ../../1-environment/eks-cp.sh
. ../../1-environment/shared.sh

