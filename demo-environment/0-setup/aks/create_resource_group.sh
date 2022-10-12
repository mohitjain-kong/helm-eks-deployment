#!/bin/bash
echo -e "\n*** Creating a resource group"
az account list-locations -o table
echo -e ""
echo -e "Please provide the location (e.g. westus)"
echo -e "Note: not all locations are available for GKE installations"
read location
az group create -l $location -n DemoEnv
