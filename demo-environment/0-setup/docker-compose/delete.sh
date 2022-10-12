#!/bin/bash
export ADDITIONAL_COMPONENTS=""
export DEMO_ENABLED_PLUGINS=""
. ./enabledFeatures.sh

docker compose -f postgres.yaml -f kong.yaml -f example-backend-services.yaml $ADDITIONAL_COMPONENTS down --remove-orphans
