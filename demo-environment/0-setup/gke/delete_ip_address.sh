#!/bin/bash
echo -e "\n*** Deleting the IP Address(es) in the following region: $GKE_REGION"
gcloud compute addresses delete $USER-demo-env-kong-ip --region=$GKE_REGION