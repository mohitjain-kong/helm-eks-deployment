#!/bin/bash
echo -e "\n*** Creating ip addresses in $created_resource_group"
uuid=$(uuidgen | tr "[:upper:]" "[:lower:]")
az network public-ip create --resource-group $created_resource_group --name kongProxy --dns-name proxy-$uuid --sku Standard --allocation-method static
az network public-ip create --resource-group $created_resource_group --name kongAdmin --dns-name admin-$uuid --sku Standard --allocation-method static
az network public-ip create --resource-group $created_resource_group --name kongManager --dns-name manager-$uuid --sku Standard --allocation-method static
az network public-ip create --resource-group $created_resource_group --name kongPortal --dns-name portal-$uuid --sku Standard --allocation-method static
az network public-ip create --resource-group $created_resource_group --name kongPortalApi --dns-name portal-api-$uuid --sku Standard --allocation-method static


