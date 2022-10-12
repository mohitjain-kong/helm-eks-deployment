#!/bin/bash

minikube --vm-driver=hyperkit --cpus 3 --memory 6144 -p minikube-kong-enterprise start --kubernetes-version=v1.21.5

kubectl apply -f ../shared/all_namespaces.yaml
kubectl apply -f ../shared/Kong/kong_license.yaml -n kong-enterprise

echo -e "Copying custom image into registry of Minikube"
minikube -p minikube-kong-enterprise cache add kong/kong-gateway:2.8.1.2

. ../shared/Mesh/install_kong_mesh.sh

echo -e "\n*** Creating secret for sessions"
kubectl create secret generic kong-session-config -n kong-enterprise --from-file=../shared/Kong/secrets/admin_gui_session_conf --from-file=../shared/Kong/secrets/portal_session_conf

kubectl create -f ../shared/Databases/postgres.yaml -n databases
while [[ $(kubectl get pods -l app=postgres -n databases -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo -e "waiting for Postgres to start..." && sleep 3; done

helm repo add kong https://charts.konghq.com
helm repo update

DEMO_VITALS_STRATEGY=database
if [ "$ENABLE_INFLUXDB" = true ] ; 
then
  DEMO_VITALS_STRATEGY=influxdb
fi

echo -e "Updating the deployment to know about external Minikube IP"


if [ "$ENABLE_HYBRID_MODE" = "true" ] ; 
then
  echo -e "ENABLE_HYBRID_MODE enabled"
  cp values-cp.yaml values-minikube-ip.yaml

  . ../../1-environment/minikube.sh
  . ../../1-environment/shared.sh

  yq -i eval ".env.proxy_url = \"$PROXY_URL\"" values-minikube-ip.yaml
  yq -i eval ".env.admin_gui_url = \"$MANAGER_URL\"" values-minikube-ip.yaml
  yq -i eval ".env.admin_api_uri = \"$ADMIN_URL\"" values-minikube-ip.yaml
  yq -i eval ".env.portal_gui_host = \"$PORTAL_HOST:$PORTAL_PORT\"" values-minikube-ip.yaml
  yq -i eval ".env.portal_api_url = \"$PORTAL_ADMIN_URL\"" values-minikube-ip.yaml
  helm install kong-enterprise kong/kong  --set ingressController.installCRDs=false --set env.plugins="$DEMO_ENABLED_PLUGINS_HELM" --set env.vitals_strategy="$DEMO_VITALS_STRATEGY" -f ./values-minikube-ip.yaml -n kong-enterprise
  helm install kong-enterprise-dataplanes kong/kong  --set ingressController.installCRDs=false --set env.plugins="$DEMO_ENABLED_PLUGINS_HELM" -f ./values-dp.yaml -n kong-enterprise --version 1.12.0

else
  cp values.yaml values-minikube-ip.yaml

  . ../../1-environment/minikube.sh
  . ../../1-environment/shared.sh

  yq -i eval ".env.proxy_url = \"$PROXY_URL\"" values-minikube-ip.yaml
  yq -i eval ".env.admin_gui_url = \"$MANAGER_URL\"" values-minikube-ip.yaml
  yq -i eval ".env.admin_api_uri = \"$ADMIN_URL\"" values-minikube-ip.yaml
  yq -i eval ".env.portal_gui_host = \"$PORTAL_HOST:$PORTAL_PORT\"" values-minikube-ip.yaml
  yq -i eval ".env.portal_api_url = \"$PORTAL_ADMIN_URL\"" values-minikube-ip.yaml
  helm install kong-enterprise kong/kong  --set ingressController.installCRDs=false --set env.plugins="$DEMO_ENABLED_PLUGINS_HELM" --set env.vitals_strategy="$DEMO_VITALS_STRATEGY" -f ./values-minikube-ip.yaml -n kong-enterprise --version 1.12.0
fi

rm values-minikube-ip.yaml

. ../shared/kubernetes_shared_install.sh

