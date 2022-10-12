#!/bin/bash
echo -e "\n*** Creating GKE cluster (will take a long time....)"
# echo -e "Press enter to start installing GKE"
# read
gcloud services enable container.googleapis.com
gcloud container clusters create $USER-demo-env --max-cpu=8 --max-memory=15 --no-enable-autoprovisioning-autoupgrade --no-enable-autoprovisioning-autorepair --enable-autoprovisioning --num-nodes=2 --region=$GKE_REGION
echo -e "\n Will sleep for 45 seconds to wait for all pods and services having started up"
sleep 45

echo -e "\n*** Attaching kubectl"
gcloud container clusters get-credentials $USER-demo-env --region=$GKE_REGION
