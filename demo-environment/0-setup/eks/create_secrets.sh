#!/bin/bash

echo -e "\n*** Creating namespace"
kubectl create namespace kong-enterprise

echo -e "\n*** Creating Secrets"
kubectl create secret generic kong-config-secret -n kong-enterprise \
    --from-literal=portal_session_conf='{"storage":"kong","secret":"password","cookie_name":"portal_session","cookie_samesite":"off","cookie_secure":false}' \
    --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"password","cookie_name":"admin_session","cookie_samesite":"off","cookie_secure":false}' \
    --from-literal=kong_admin_password=kong

kubectl create secret generic kong-enterprise-postgresql -n kong-enterprise \
    --from-literal=postgres-password=kong \
    --from-literal=password=kong

# echo -e "\n*** Creating secret for sessions"
# kubectl create secret generic kong-session-config -n kong-enterprise-enterprise --from-file=admin_gui_session_conf --from-file=portal_session_conf

echo -e "\n*** Creating secret for license"
kubectl create secret generic kong-enterprise-license -n kong-enterprise --from-file=./license


# helm upgrade -i kong kong/kong -n kong-enterprise -f ./values-ak.yaml

# kubectl port-forward pod/kong-kong-857f7f754-7l64k -n kong-enterprise 8001:8001 8002:8002