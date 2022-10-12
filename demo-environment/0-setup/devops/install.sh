#!/bin/bash

echo -e "This script will the demo env in the devops system on GKE"
echo -e "Keep in mind that this service is cost intensive so delete it as soon as you do not need it anymore more with the also included delete.sh script"
echo -e "*** Prerequesites"
echo -e "*** 1. A Google account"
echo -e "*** 2. gcloud cli installed on your machine"
echo -e "*** 3. kubectl"
echo -e "*** 4. jq"
echo -e "******************************************"
echo -e "For your convenience you can create a script to set your defaults. A template can be found at 0-setup/devops/env_example_script.sh"
echo
echo -e "If you are ready go press ENTER, otherwise stop now using ctrl-c"
read

gcloud auth login

echo -e "* Collecting needed data for setting up the cluster"

echo -e ""
echo -e "Please enter your Okta username (defaults to value of DEVOPS_USERNAME environment variable): " 
read devops_username_entered
devops_username=${devops_username_entered:-$DEVOPS_USERNAME}

echo -e ""
echo -e "Please enter your Okta password (defaults to value of DEVOPS_PASSWORD environment variable): " 
read devops_entered
devops_password=${devops_password_entered:-$DEVOPS_PASSWORD}

echo -e ""
echo -e "Please enter your GitHub owner username (defaults to value of DEVOPS_GITHUB_USERNAME environment variable): " 
read devops_gitowner_entered
devops_gitowner=${devops_gitowner_entered:-$DEVOPS_GITHUB_USERNAME}

echo -e ""
echo -e "Please enter your GitHub token (defaults to value of DEVOPS_GITHUB_TOKEN environment variable): " 
read devops_github_token_entered
devops_github_token=${devops_github_token_entered:-$DEVOPS_GITHUB_TOKEN}

echo -e ""
echo -e "Please enter your desired global/standalone zone region in GCloud. Example: us-central1-a All available zones can be listed with \"gcloud compute zones list\" (defaults to value of DEVOPS_GLOBAL_REGION environment variable): " 
read devops_global_zone_entered
devops_global_zone=${devops_global_zone_entered:-$DEVOPS_GLOBAL_REGION}

echo -e ""
echo -e "Please enter your desired mode (standalone, multizone, gitops). (defaults to value of DEVOPS_MODE environment variable): " 
read devops_mode_entered
devops_mode=${devops_mode_entered:-$DEVOPS_MODE}

if [ "$devops_mode" = "multizone" ]; then
  echo -e ""
  echo -e "Please enter your desired first remote zone region in GCloud. Example: us-west1-a All available zones can be listed with \"gcloud compute zones list\" (defaults to value of DEVOPS_ZONE1_REGION environment variable):" 
  read devops_zone1_entered
devops_zone1=${devops_zone1:-$DEVOPS_ZONE1}

  echo -e ""
  echo -e "Please enter your desired second remote zone region in GCloud. Example: us-east1-a All available zones can be listed with \"gcloud compute zones list\" (defaults to value of DEVOPS_ZONE2_REGION environment variable):" 
  read devops_zone2_entered
devops_zone2=${devops_zone2:-$DEVOPS_ZONE2}
fi

echo -e ""
echo -e "Please enter the planned expiry in seconds (defaults to value of DEVOPS_EXPIRY environment variable): " 
read devops_expiry_entered
devops_expiry=${devops_expiry_entered:-$DEVOPS_EXPIRY}

if [ "$devops_mode" = "standalone" ]; then
  echo -e ""
  echo -e "Creating standalone cluster now"
  cluster_name=$(http POST https://ops.kong-sales-engineering.com/ops/create \
    environmentName="$devops_gitowner-standalone-local" \
    mode=standalone \
    zone=$devops_global_zone \
    expiryInSeconds=$devops_expiry \
    gitOwner="$devops_gitowner" \
    gitToken="$devops_github_token" \
    Content-Type:application/json \
    --verify=no \
    -a $devops_username:$devops_password \
  | jq -r '.cluster_name' )

elif [ "$devops_mode" = "multizone" ]; then
  echo -e ""
  echo -e "Creating multizone cluster now"
  cluster_name=$(http POST https://ops.kong-sales-engineering.com/ops/create \
    environmentName="$devops_gitowner-multi-local" \
    mode=multizone \
    global_zone=$devops_global_zone \
    west_zone=$devops_zone1 \
    east_zone=$devops_zone2 \
    expiryInSeconds=$devops_expiry \
    gitOwner="$devops_gitowner" \
    gitToken="$devops_github_token" \
    Content-Type:application/json \
    --verify=no \
    -a $devops_username:$devops_password \
  | jq -r '.cluster_name' )
elif [ "$devops_mode" = "apiops" ]; then
  echo -e ""
  echo -e "Creating apiops cluster now"
  cluster_name=$(http POST https://ops.kong-sales-engineering.com/ops/create \
    environmentName="$devops_gitowner-apiops-local" \
    mode=apiops \
    global_zone=$devops_global_zone \
    west_zone=$devops_zone1 \
    east_zone=$devops_zone2 \
    expiryInSeconds=$devops_expiry \
    gitOwner="$devops_gitowner" \
    gitToken="$devops_github_token" \
    Content-Type:application/json \
    --verify=no \
    -a $devops_username:$devops_password \
  | jq -r '.cluster_name' )
fi

echo -e "* Cluster $cluster_name creation initiated - waiting now for startup completed"
echo -e "Logs are available at  ~/.demo-env/devops.log"
echo "" > ~/.demo-env/devops.log
while true
do
    cluster_info=$(http --verify=no --ignore-stdin https://ops.kong-sales-engineering.com/ops/info key==$cluster_name -a $devops_username:$devops_password )
    echo $cluster_info >> ~/.demo-env/devops.log
    repo_info=$( echo $cluster_info | jq -r '.repo_info' )
    echo $repo_info  >> ~/.demo-env/devops.log
    if [ "$repo_info" = "null" ]; then
        echo -e "Creation in progress - will wait another 30 seconds"
        sleep 30
    else
        echo -e "Cluster started"
        break
    fi
done

echo -e "* Gathering the install details and storing them in ~/.demo-env/.devops_details.sh"
ADMIN_URL=$(echo $repo_info | jq -r '.gitSecrets[] | select(.secret == "ADMIN_API_URL") | .value')
DEVOPS_ZONE=$(echo $repo_info | jq -r '.gitSecrets[] | select(.secret == "ZONE_NAME") | .value')
echo "#!/bin/bash" > ~/.demo-env/.devops_details.sh
chmod a+x ~/.demo-env/.devops_details.sh
echo -e "export DEVOPS_CLUSTER_NAME=\"$cluster_name\"" >> ~/.demo-env/.devops_details.sh
echo -e "export ADMIN_HOST=\"fake\"" >> ~/.demo-env/.devops_details.sh
echo -e "export ADMIN_PORT=\"1234\"" >> ~/.demo-env/.devops_details.sh
echo -e "export ADMIN_URL=\"$ADMIN_URL\"" >> ~/.demo-env/.devops_details.sh
echo -e "export MANAGER_URL=\"https://$cluster_name-manager.kong-sales-engineering.com:8445\"" >> ~/.demo-env/.devops_details.sh
echo -e "export PORTAL_URL=\"http://$cluster_name-portal.kong-sales-engineering.com:8003\"" >> ~/.demo-env/.devops_details.sh
echo -e "export GRAFANA_MESH=\"http://$cluster_name-grafana.kong-sales-engineering.com\"" >> ~/.demo-env/.devops_details.sh

echo -e "export DEVOPS_CLUSTER_NAME=\"$cluster_name\""
echo -e "export ENABLE_CUSTOM_PLUGINS=false" >> ~/.demo-env/.devops_details.sh

gcloud container clusters get-credentials $cluster_name --zone $DEVOPS_ZONE --project sales-engineering-282713

PROXY_HOST=$(kubectl get services -n se-kong-mesh -o json | jq -r '[.items[] | {ingress:.status.loadBalancer.ingress,name:.metadata.name}]' | jq -r '.[] | select(.name|test("kong-mesh-demo-kong-proxy")) | .ingress[0].ip')
echo -e "export PROXY_URL=\"http://$PROXY_HOST\"" >> ~/.demo-env/.devops_details.sh
echo -e "export MESH_URL=\"http://$PROXY_HOST/kuma/gui/\"" >> ~/.demo-env/.devops_details.sh

source ../../1-environment/devops.sh
kubectl apply -f ../shared/all_namespaces.yaml
. ../shared/kubernetes_shared_install.sh
