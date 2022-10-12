#!/bin/bash
echo -e "\n*** Creating an IP Address in the following region: $GKE_REGION"
gcloud compute addresses create $USER-demo-env-kong-ip --region=$GKE_REGION