#!/bin/bash

external_ip=$(gcloud compute addresses describe $USER-demo-env-kong-ip --region=$GKE_REGION --format=json | jq -r '.address')

export PROXY_HOST=$external_ip
export PROXY_PORT=80

export ADMIN_HOST=$external_ip
export ADMIN_PORT=8001

export MANAGER_HOST=$external_ip
export MANAGER_PORT=8002

export PORTAL_HOST=$external_ip
export PORTAL_PORT=8003

export PORTAL_ADMIN_HOST=$external_ip
export PORTAL_ADMIN_PORT=8004


