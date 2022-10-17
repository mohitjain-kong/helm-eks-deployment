#!/bin/bash

echo -e "\n*** Creating CP namespace"
kubectl create namespace kong-hybrid-cp

echo -e "\n*** Creating CP Secrets"
kubectl create secret generic kong-config-secret -n kong-hybrid-cp \
    --from-literal=portal_session_conf='{"storage":"kong","secret":"password","cookie_name":"portal_session","cookie_samesite":"off","cookie_secure":false}' \
    --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"password","cookie_name":"admin_session","cookie_samesite":"off","cookie_secure":false}' \
    --from-literal=kong_admin_password=kong

kubectl create secret generic kong-hybrid-cp-postgresql -n kong-hybrid-cp \
    --from-literal=postgres-password=kong \
    --from-literal=password=kong

# echo -e "\n*** Creating CP secret for sessions"
# kubectl create secret generic kong-session-config -n kong-hybrid-cp-enterprise --from-file=admin_gui_session_conf --from-file=portal_session_conf

echo -e "\n*** Creating CP secret for license"
kubectl create secret generic kong-hybrid-cp-license -n kong-hybrid-cp --from-file=./license


echo -e "\n*** Create a secret containing the certificates for the Control Plane"
kubectl create secret tls kong-cluster-cert --cert=cluster.crt --key=cluster.key -n kong-hybrid-cp


# helm upgrade -i kong kong/kong -n kong-enterprise -f ./values-ak.yaml

# kubectl port-forward pod/kong-kong-857f7f754-7l64k -n kong-enterprise 8001:8001 8002:8002