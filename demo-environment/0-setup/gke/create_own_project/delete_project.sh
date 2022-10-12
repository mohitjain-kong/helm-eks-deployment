#!/bin/bash
echo -e "\n*** Deleting ressource group"
MAC_UUID=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | tr "[:upper:]" "[:lower:]")
export GCP_PROJECT_ID=kong-demo-$MAC_UUID
gcloud projects delete $GCP_PROJECT_ID

echo -e "!!! Deletion of a project is on hold by GCP for 30 days by default. Creating a new one with the project-id \"$GCP_PROJECT_ID\" isn't possible in that time - only undelete is possible"
