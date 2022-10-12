#!/bin/bash
unset PROXY_URL
unset ADMIN_URL
unset MANAGER_URL
unset PORTAL_HOST
unset PORTAL_ADMIN_URL
#until [ ! "$PROXY_URL" = "" ] && [ ! "$ADMIN_URL" = "" ] && [ ! "$MANAGER_URL" = "" ]  && [ ! "$PORTAL_HOST" = "" ] && [ ! "$PORTAL_ADMIN_URL" = "" ] && [ ! "$PROXY_URL" = "null" ] && [ ! "$ADMIN_URL" = "null" ] && [ ! "$MANAGER_URL" = "null" ]  && [ ! "$PORTAL_HOST" = "null" ] && [ ! "$PORTAL_ADMIN_URL" = "null" ]
#do
#  echo -e "Waiting until all AWS load balancers got a DNS attached"
#  sleep 5
  . ../../1-environment/eks.sh
  . ../../1-environment/shared.sh

#done

echo -e "Here we go - applying the loadbalancer addresses to the kong-dp.yaml file"

yq -i eval ".env.proxy_url = \"$PROXY_URL\"" kong-dp.yaml
# yq -i eval ".env.admin_gui_url = \"$MANAGER_URL\"" kong-dp.yaml
# yq -i eval ".env.admin_api_uri = \"$ADMIN_URL\"" kong-dp.yaml
# yq -i eval ".env.portal_gui_host = \"$PORTAL_HOST:$PORTAL_PORT\"" kong-dp.yaml
# yq -i eval ".env.portal_api_url = \"$PORTAL_ADMIN_URL\"" kong-dp.yaml
