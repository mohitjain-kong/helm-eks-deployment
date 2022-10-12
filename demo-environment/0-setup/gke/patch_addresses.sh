#!/bin/bash
external_ip=$(gcloud compute addresses describe $USER-demo-env-kong-ip --region=$GKE_REGION --format=json | jq -r '.address')
cp values.yaml.template values.yaml

yq -i eval ".env.proxy_url = \"$PROXY_URL\"" values.yaml
yq -i eval ".env.admin_gui_url = \"$MANAGER_URL\"" values.yaml
yq -i eval ".env.admin_api_uri = \"$ADMIN_URL\"" values.yaml
yq -i eval ".env.portal_gui_host = \"$PORTAL_HOST:$PORTAL_PORT\"" values.yaml
yq -i eval ".env.portal_api_url = \"$PORTAL_ADMIN_URL\"" values.yaml

yq -i eval ".proxy.loadBalancerIP = \"$external_ip\"" values.yaml
yq -i eval ".admin.loadBalancerIP = \"$external_ip\"" values.yaml
yq -i eval ".manager.loadBalancerIP = \"$external_ip\"" values.yaml
yq -i eval ".portal.loadBalancerIP = \"$external_ip\"" values.yaml
yq -i eval ".portalapi.loadBalancerIP = \"$external_ip\"" values.yaml