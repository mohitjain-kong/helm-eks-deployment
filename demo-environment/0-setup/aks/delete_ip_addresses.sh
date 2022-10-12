#!/bin/bash
echo -e "\n*** Deleting ip addresses"
export created_resource_group=$(az aks show --name DemoEnv -g DemoEnv | jq -r '.nodeResourceGroup')
az network public-ip delete --resource-group $created_resource_group --name kongProxy
az network public-ip delete --resource-group $created_resource_group --name kongAdmin
az network public-ip delete --resource-group $created_resource_group --name kongManager
az network public-ip delete --resource-group $created_resource_group --name kongPortal
az network public-ip delete --resource-group $created_resource_group --name kongPortalApi