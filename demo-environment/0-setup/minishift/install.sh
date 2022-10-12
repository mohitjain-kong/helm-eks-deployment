#!/bin/bash
echo -e "*** Logging in with default credentials"
oc login -u developer

echo -e "\n*** Creating project"
oc new-project kong-enterprise

echo -e "\n*** Creating Postgres"
oc create -f postgres.yaml
echo -e "\n... waiting a few seconds for Postgres to start\n"
sleep 5

echo -e "\n*** Storing license as a secret"
oc create -f ../shared/kong_license.yaml

echo -e "\n*** Initiating Kong migration"
oc create -f kong_migration_postgres.yaml
echo -e "\n... waiting a few seconds for Kong to finish migration\n"
sleep 5

echo -e "\n*** Deploying Kong"
oc create -f kong_postgres.yaml 

echo -e "\n*** Creating example backend services"
oc create -f ../shared/Backends/httpbin.yaml 
oc create -f ../shared/Backends/anotherHttpbin.yaml
oc create -f ../shared/Backends/jsonplaceholder.yaml

echo -e "\n*** Adding additional components"
if [ "$ENABLE_REDIS" = true ] ; 
then
  oc create -f redis.yaml
fi

if [ "$ENABLE_OPENLDAP" = true ] ; 
then
  oc create -f openldap.yaml
fi



./patch_settings.sh

if [ "$ENABLE_INGRESS_CONTROLLER" = true ]; 
then
  ./install_ingress.sh
fi

echo -e "\n"
. ../../1-environment/minishift.sh
. ../../1-environment/shared.sh
