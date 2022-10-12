#!/bin/bash
cp values.yaml.template values.yaml

yq -i eval ".env.proxy_url = \"$PROXY_URL\"" values.yaml
yq -i eval ".env.admin_gui_url = \"$MANAGER_URL\"" values.yaml
yq -i eval ".env.admin_api_uri = \"$ADMIN_URL\"" values.yaml
yq -i eval ".env.portal_gui_host = \"$PORTAL_HOST\"" values.yaml
yq -i eval ".env.portal_api_url = \"$PORTAL_ADMIN_URL\"" values.yaml

yq -i eval ".proxy.loadBalancerIP = \"$loadBalancerIP\"" values.yaml
yq -i eval ".admin.loadBalancerIP = \"$AKS_ADMIN_IP\"" values.yaml
yq -i eval ".manager.loadBalancerIP = \"$AKS_MANAGER_IP\"" values.yaml
yq -i eval ".portal.loadBalancerIP = \"$AKS_PORTAL_IP\"" values.yaml
yq -i eval ".portalapi.loadBalancerIP = \"$AKS_PORTAL_API_IP\"" values.yaml

yq -i eval ".proxy.annotations.\"service.beta.kubernetes.io/azure-load-balancer-resource-group\" = \"$created_resource_group\"" values.yaml
yq -i eval ".admin.annotations.\"service.beta.kubernetes.io/azure-load-balancer-resource-group\" = \"$created_resource_group\"" values.yaml
yq -i eval ".manager.annotations.\"service.beta.kubernetes.io/azure-load-balancer-resource-group\" = \"$created_resource_group\"" values.yaml
yq -i eval ".portal.annotations.\"service.beta.kubernetes.io/azure-load-balancer-resource-group\" = \"$created_resource_group\"" values.yaml
yq -i eval ".portalapi.annotations.\"service.beta.kubernetes.io/azure-load-balancer-resource-group\" = \"$created_resource_group\"" values.yaml


jq ".cookie_domain = \".$AKS_LOCATION.cloudapp.azure.com\"" admin_gui_session_conf.template > admin_gui_session_conf
jq ".cookie_domain = \".$AKS_LOCATION.cloudapp.azure.com\"" portal_session_conf.template > portal_session_conf
