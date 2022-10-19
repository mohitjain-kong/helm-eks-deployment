#!/bin/bash
export DEMO_ENV=kubernetes
export ADMIN_HOST=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}' | awk -F: '{print $2}' | sed 's:^/*::')
export PROXY_HOST=$ADMIN_HOST
export MANAGER_HOST=$ADMIN_HOST
export PORTAL_HOST=$ADMIN_HOST
export PORTAL_ADMIN_HOST=$ADMIN_HOST
export ADMIN_PORT=$(oc get services kong-admin -o json | jq '.spec.ports[0].nodePort')
export PROXY_PORT=$(oc get services kong-proxy -o json | jq '.spec.ports[0].nodePort')
export MANAGER_PORT=$(oc get services kong-manager -o json | jq '.spec.ports[0].nodePort')
export PORTAL_PORT=$(oc get services kong-portal -o json | jq '.spec.ports[0].nodePort')
export PORTAL_ADMIN_PORT=$(oc get services kong-portal-admin -o json | jq '.spec.ports[0].nodePort')


