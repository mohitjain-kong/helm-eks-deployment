#!/bin/bash

# Check if Docker is running
docker_state=$(docker info >/dev/null 2>&1)
if [[ $? -ne 0 ]]; then
    echo -e "Docker does not seem to be running, run it first and retry"
    exit 1
fi

export env_file=default.env

. ./enabledFeatures.sh

ADDITIONAL_COMPONENTS=" -f postgres.yaml -f example-backend-services.yaml $ADDITIONAL_COMPONENTS"

if [ "$ENABLE_HYBRID_MODE" = "true" ] ; 
then
  echo -e "ENABLE_HYBRID_MODE enabled"
  DEMO_ENABLED_PLUGINS=$DEMO_ENABLED_PLUGINS docker compose --env-file ./$env_file -f kong-cp.yaml -f optional-features/kong-dataplane-nodes.yaml $ADDITIONAL_COMPONENTS up -d
else
  DEMO_ENABLED_PLUGINS=$DEMO_ENABLED_PLUGINS docker compose --env-file ./$env_file -f kong.yaml $ADDITIONAL_COMPONENTS up -d
fi

echo -e "\n"
. ../../1-environment/docker-compose.sh
. ../../1-environment/shared.sh
