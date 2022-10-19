#!/bin/bash
export DEMO_ENV=minishift
export ADMIN_HOST=$(minishift ip)
export PROXY_HOST=$ADMIN_HOST
export MANAGER_HOST=$ADMIN_HOST
export PORTAL_HOST=$ADMIN_HOST
export PORTAL_ADMIN_HOST=$ADMIN_HOST
export ADMIN_PORT=$(oc get services kong-admin -o json | jq '.spec.ports[0].nodePort')
export PROXY_PORT=$(oc get services kong-proxy -o json | jq '.spec.ports[0].nodePort')
export PROXY_SSL_PORT=$(oc get services kong-proxy-ssl -o json | jq '.spec.ports[0].nodePort')
export MANAGER_PORT=$(oc get services kong-manager -o json | jq '.spec.ports[0].nodePort')
export PORTAL_PORT=$(oc get services kong-portal -o json | jq '.spec.ports[0].nodePort')
export PORTAL_ADMIN_PORT=$(oc get services kong-portal-admin -o json | jq '.spec.ports[0].nodePort')


