#!/bin/bash
echo -e "\n*** Deleting cluster (this will take a while...)"
gcloud container clusters delete $USER-demo-env --region=$GKE_REGION
