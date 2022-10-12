#!/bin/bash
echo -e "\n*** Creating service principal"
principal=$(az ad sp create-for-rbac --skip-assignment)
app_id=$(echo $principal | jq -r  '.appId')
password=$(echo $principal | jq -r '.password')
echo $principal
echo -e "AppId:    $app_id"
echo -e "Password: $password"
echo -e "\n*** Adding permission to change network access for principal"
echo -e "We have to wait for 30 seconds until the principal is fully available..."
sleep 30
subscription_id=$(az account show | jq -r  '.id')
az role assignment create \
    --assignee $app_id \
    --role "Network Contributor" \
    --scope /subscriptions/$subscription_id/resourceGroups/DemoEnv


echo -e "\n*** Creating AKS cluster (will take a long time....)"
# echo -e "Press enter to start installing AKS"
# read
az aks create -g DemoEnv -n DemoEnv --service-principal $app_id --client-secret $password

echo -e "\n*** Extending permissions of principle to the auto generated resource group"

export created_resource_group=$(az aks show --name DemoEnv -g DemoEnv | jq -r '.nodeResourceGroup')
echo -e "The created resource group has the name $created_resource_group"

az role assignment create \
    --assignee $app_id \
    --role "Network Contributor" \
    --scope /subscriptions/$subscription_id/resourceGroups/$created_resource_group


echo -e "\n*** Attaching kubectl"
az aks get-credentials --name DemoEnv --resource-group DemoEnv
