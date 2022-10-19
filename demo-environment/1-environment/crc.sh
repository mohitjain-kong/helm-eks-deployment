#!/bin/bash
export DEMO_ENV=crc
export ADMIN_HOST=api.crc.testing
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
export DECK_KONG_ADDR=$ADMIN_URL

echo -e "To see the web user interface open https://console-openshift-console.apps-crc.testing/ with username and password developer"


