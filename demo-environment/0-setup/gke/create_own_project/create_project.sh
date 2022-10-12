#!/bin/bash
echo -e "\n*** Creating the project"
# We need a unique id we are able to replicate so we are using an ID of the Mac
export MAC_UUID=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | tr "[:upper:]" "[:lower:]")
export GCP_PROJECT_ID=kong-demo-$MAC_UUID
if [ `gcloud projects create $GCP_PROJECT_ID --name DemoEnv` ]
then
  echo -e "New project $GCP_PROJECT_ID has been created"
else
  echo -e "\n\n!!! Project $GCP_PROJECT_ID already in the your account - trying to restore !!!\n"
  gcloud projects undelete $GCP_PROJECT_ID
fi
gcloud config set project $GCP_PROJECT_ID
echo -e "\n*** Enabling billing..."
gcloud beta billing accounts list
echo -e "Please enter the Billing ID to be used: "
read billing_account
gcloud beta billing projects link $GCP_PROJECT_ID --billing-account $billing_account

gcloud compute zones list
echo -e ""
echo -e "Please provide a GKE zone (e.g. us-east1-b or europe-west3-b): "
read zone

gcloud config set compute/zone $zone
export GKE_ZONE=$zone

# Calculating GKE region based on the zone. The string below extracts the characters before the LAST - (dash)
# By doing this, we should get the GKE region.
export GKE_REGION=${zone%-*}

echo -e "\n*** The CALCULATED GKE region has been set to: "
echo $GKE_REGION
echo -e "Note that the value should be something similar to: asia-east1, us-east1, europe-west3, etc)"

# setting this config value for future use
gcloud config set compute/region $GKE_REGION
