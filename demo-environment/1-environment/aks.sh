#!/bin/bash
export created_resource_group=$(az aks show --name DemoEnv -g DemoEnv | jq -r '.nodeResourceGroup')
proxy_data=$(az network public-ip show --resource-group $created_resource_group --name kongProxy)
location=$(echo $proxy_data  | jq -r '.location')
proxy_fqdn=$(echo $proxy_data | jq -r '.dnsSettings.fqdn')
proxy_ip=$(echo $proxy_data | jq -r '.ipAddress')
export AKS_PROXY_IP=$proxy_ip

admin_data=$(az network public-ip show --resource-group $created_resource_group --name kongAdmin)
admin_fqdn=$(echo $admin_data | jq -r '.dnsSettings.fqdn')
admin_ip=$(echo $admin_data | jq -r '.ipAddress')
export AKS_ADMIN_IP=$admin_ip
export DECK_KONG_ADDR=$ADMIN_URL

manager_data=$(az network public-ip show --resource-group $created_resource_group --name kongManager)
manager_fqdn=$(echo $manager_data | jq -r '.dnsSettings.fqdn')
manager_ip=$(echo $manager_data | jq -r '.ipAddress')
export AKS_MANAGER_IP=$manager_ip

portal_data=$(az network public-ip show --resource-group $created_resource_group --name kongPortal)
portal_fqdn=$(echo $portal_data | jq -r '.dnsSettings.fqdn')
portal_ip=$(echo $portal_data | jq -r '.ipAddress')
export AKS_PORTAL_IP=$portal_ip

portal_api_data=$(az network public-ip show --resource-group $created_resource_group --name kongPortalApi)
portal_api_fqdn=$(echo $portal_api_data | jq -r '.dnsSettings.fqdn')
portal_api_ip=$(echo $portal_api_data | jq -r '.ipAddress')
export AKS_PORTAL_API_IP=$portal_api_ip

export PROXY_HOST=$proxy_fqdn
export PROXY_PORT=80

export ADMIN_HOST=$admin_fqdn
export ADMIN_PORT=80

export MANAGER_HOST=$manager_fqdn
export MANAGER_PORT=80

export PORTAL_HOST=$portal_fqdn
export PORTAL_PORT=80

export PORTAL_ADMIN_HOST=$portal_api_fqdn
export PORTAL_ADMIN_PORT=80

export AKS_LOCATION=$location

