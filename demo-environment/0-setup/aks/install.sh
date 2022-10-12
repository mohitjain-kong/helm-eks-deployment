#!/bin/bash
echo -e "This script will install a fresh Kubernetes cluster in Azure (AKS)"
echo -e "Keep in mind that this service is cost intensive so delete it as soon as you do not need it anymore more with the also included delete.sh script"
echo -e "*** Prerequesites"
echo -e "*** 1. An Azure account (obviously)"
echo -e "*** 2. Azure cli installed on your machine"
echo -e "*** 3. kubectl"
echo -e "*** 4. Helm (version 3, not version 2!)"
echo -e "*** 5. yq"
echo -e "*** 6. jq"
echo -e "******************************************"
echo
echo -e "If you are ready go press ENTER, otherwise stop now using ctrl-c"
read


az login
. ./create_resource_group.sh
. ./create_k8s_cluster.sh
. ./create_ip_addresses.sh
. ../../1-environment/aks.sh
. ../../1-environment/shared.sh
. ./patch_adresses.sh

echo -e "\n*** Creating namespace"
kubectl create namespace kong-enterprise


echo -e "\n*** Creating secret for sessions"
kubectl create secret generic kong-session-config -n kong-enterprise --from-file=admin_gui_session_conf --from-file=portal_session_conf

echo -e "\n*** Creating secret for license"
kubectl create secret generic kong-enterprise-license -n kong-enterprise --from-file=./license


echo -e "\n*** Creating secret for super-admin password"
kubectl create secret generic kong-enterprise-superuser-password -n kong-enterprise --from-literal=password=KongRul3z!

echo -e "\n*** Installing Kong Enterprise"
# AKS now needs to have the PVC with class name specific to AKS - so we create it in advance
kubectl apply -f aks_pvc.yaml -n kong-enterprise
helm repo update
helm install kong-enterprise kong/kong --set ingressController.installCRDs=false -f ./values.yaml -n kong-enterprise

. ../../1-environment/aks.sh
. ../../1-environment/shared.sh

rm admin_gui_session_conf
rm portal_session_conf
rm values.yaml
