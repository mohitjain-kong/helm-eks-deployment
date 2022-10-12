#!/bin/bash
echo -e "This script will install a fresh Kubernetes cluster in Google Cloud (GCP / GKE)"
echo -e "Keep in mind that this service is cost intensive so delete it as soon as you do not need it anymore more with the also included delete.sh script"
echo -e "*** Prerequesites"
echo -e "*** 1. A Google account (obviously)"
echo -e "*** 2. gcloud cli installed on your machine"
echo -e "*** 3. kubectl"
echo -e "*** 4. Helm (version 3, not version 2!)"
echo -e "*** 5. yq"
echo -e "*** 6. jq"
echo -e "******************************************"
echo
echo -e "If you are ready go press ENTER, otherwise stop now using ctrl-c"
read

gcloud auth login

echo -e "Enter your project ID (there is a shared one for SEs, sales-engineering-282713, you might need to ask for access):"
read GKE_PROJECT_ID
export GKE_PROJECT_ID

echo -e "Updating the selected project to your current project..."
gcloud config set project $GKE_PROJECT_ID

gcloud compute regions list
echo -e "Enter the region you wish to deploy your GKE resources:"
read GKE_REGION
export GKE_REGION

. ./create_k8s_cluster.sh
. ./create_ip_address.sh
. ../../1-environment/gke.sh
. ../../1-environment/shared.sh
. ./patch_addresses.sh

kubectl apply -f ../shared/all_namespaces.yaml
kubectl apply -f ../shared/Kong/kong_license.yaml -n kong-enterprise
. ../shared/Mesh/install_kong_mesh.sh


echo -e "\n*** Creating secret for sessions"
kubectl create secret generic kong-session-config -n kong-enterprise --from-file=../shared/Kong/secrets/admin_gui_session_conf --from-file=../shared/Kong/secrets/portal_session_conf

helm repo add kong https://charts.konghq.com
helm repo update
echo -e "\n\n**** Kubernetes is now up&running - installing Kong using Helm" 
helm install kong-enterprise kong/kong  --set ingressController.installCRDs=false -f ./values.yaml -n kong-enterprise --version 2.10.2

. ../shared/kubernetes_shared_install.sh

. ../../1-environment/gke.sh
. ../../1-environment/shared.sh

rm values.yaml