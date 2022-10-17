#!/bin/bash
. ./create_secrets_dp.sh

cp kong-dp.yaml.template kong-dp.yaml

echo -e "\n*** Installing Kong DP Enterprise"
helm install kong-hybrid-dp kong/kong -n kong-hybrid-dp --values ./kong-dp.yaml

echo -e "\n ☕ Installation done - load balancers on AWS will need a while so we'll wait now for two minutes as we need their dns entries"
sleep 120
. ./patch_addresses_dp.sh

echo -e "\n*** Loadbalancer have been created and external dns is known - we are upgrading the Helm setup now to the created addresses"
helm upgrade --install kong-hybrid-dp kong/kong -n kong-hybrid-dp --values ./kong-dp.yaml

. ../../1-environment/eks-dp.sh
. ../../1-environment/shared.sh

