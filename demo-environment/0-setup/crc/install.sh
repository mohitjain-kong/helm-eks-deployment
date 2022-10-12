#!/bin/bash
echo -e "*** Logging in default credentials"
oc login -u developer -p developer https://api.crc.testing:6443

echo -e "\n*** Creating project"
oc new-project kong-enterprise

echo -e "\n*** Creating Postgres"
oc create -f postgres.yaml
echo -e "\n... waiting a few seconds for Postgres to start\n"
sleep 5

echo -e "\n*** Storing license as a secret"
oc create -f ../shared/Kong/kong_license.yaml

echo -e "\n*** Deploying Kong"
helm install kong-enterprise kong/kong  --set ingressController.installCRDs=false -f ./values.yaml -n kong-enterprise --set volumePermissions.securityContext.runAsUser="auto"

echo -e "\n*** Creating example backend services"
oc create -f ../shared/Backends/httpbin.yaml 
oc create -f ../shared/Backends/anotherHttpbin.yaml
oc create -f ../shared/Backends/jsonplaceholder.yaml

echo -e "\n*** Adding additional components"
if [ "$ENABLE_REDIS" = true ] ; 
then
  oc create -f redis.yaml
fi

if [ "$ENABLE_ENABLE_OPENLDAP" = true ] ; 
then
  oc create -f openldap.yaml
fi

./patch_settings.sh

echo -e "\n"
. ../../1-environment/crc.sh
. ../../1-environment/shared.sh
