#!/bin/bash
version_string=$(k3d --version | head -1 )
export ENABLE_CUSTOM_PLUGINS=false

if [[ "$version_string" =~ ^k3d\ version\ v5.* ]]; then
  echo "k3d version 5 installed"
  k3d cluster create KongEnterprise -i rancher/k3s:v1.21.5-k3s1 --k3s-arg '--no-deploy=traefik@server:0' --k3s-arg '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%@server:0' --k3s-arg '--kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%@server:0' -p '9000:31000@agent:0' -p '9001:31001@agent:0' -p '9002:31002@agent:0' -p '9003:31003@agent:0' -p '9004:31004@agent:0' -p '9009:31009@agent:0' -p '9030:31030@agent:0' -p '9100:31100@agent:0' -p '9101:31101@agent:0' -p '9110:31110@agent:0' -p '9111:31111@agent:0' -p '9120:31120@agent:0' -p '9122:31122@agent:0' -p '9130:31130@agent:0' -p '9140:31140@agent:0' -p '9141:31141@agent:0' -p '9800:31800@agent:0' -p '9303:31303@agent:0' -p '9443:31443@agent:0'  --agents 1
elif [[ "$version_string" =~ ^k3d\ version\ v4.* ]]; then
  echo "k3d version 4 installed"
  k3d cluster create KongEnterprise -i rancher/k3s:v1.21.5-k3s1 --k3s-server-arg '--no-deploy=traefik' -p '9000:31000@agent[0]' -p '9001:31001@agent[0]' -p '9002:31002@agent[0]' -p '9003:31003@agent[0]' -p '9004:31004@agent[0]' -p '9009:31009@agent[0]' -p '9030:31030@agent[0]' -p '9100:31100@agent[0]' -p '9101:31101@agent[0]' -p '9110:31110@agent[0]' -p '9111:31111@agent[0]' -p '9120:31120@agent[0]' -p '9122:31122@agent[0]' -p '9130:31130@agent[0]' -p '9140:31140@agent[0]' -p '9141:31141@agent[0]' -p '9800:31800@agent[0]' -p '9303:31303@agent[0]' -p '9443:31443@agent[0]' --agents 1 --k3s-agent-arg '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%' --k3s-agent-arg '--kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%'
else
   echo "Unknown version of k3d installed" 
   echo "!!! Please hit ctrl-c to stop this script and install a supported version of k3d"
   read  
fi

kubectl apply -f ../shared/all_namespaces.yaml
kubectl apply -f ../shared/Kong/kong_license.yaml -n kong-enterprise

. ../shared/Mesh/install_kong_mesh.sh


echo -e "\n*** Creating secret for sessions"
kubectl create secret generic kong-session-config -n kong-enterprise --from-file=../shared/Kong/secrets/admin_gui_session_conf --from-file=../shared/Kong/secrets/portal_session_conf

echo -e "\n*** Creating secret for hybrid"
kubectl create secret generic kong-hybrid-certificate -n kong-enterprise --from-file=../shared/Kong/hybrid/cluster.crt --from-file=../shared/Kong/hybrid/cluster.key

DEMO_VITALS_STRATEGY=database
if [ "$ENABLE_INFLUXDB" = true ] ; 
then
  DEMO_VITALS_STRATEGY=influxdb
fi


kubectl create -f ../shared/Databases/postgres.yaml -n databases
while [[ $(kubectl get pods -l app=postgres -n databases -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo -e "waiting for Postgres to start..." && sleep 3; done
echo -e "Waiting some more seconds for Postgres being 100% up"
sleep 5
helm repo add kong https://charts.konghq.com
helm repo update

DEMO_ENABLED_PLUGINS_HELM=bundled
if [ "$ENABLE_HYBRID_MODE" = "true" ] ; 
then
  echo -e "ENABLE_HYBRID_MODE enabled"
  helm install kong-enterprise kong/kong  --set ingressController.installCRDs=false --set env.plugins="$DEMO_ENABLED_PLUGINS_HELM" --set env.vitals_strategy="$DEMO_VITALS_STRATEGY" -f ./values-cp.yaml -n kong-enterprise --version 2.3.0
  helm install kong-enterprise-dataplanes kong/kong  --set ingressController.installCRDs=false --set env.plugins="$DEMO_ENABLED_PLUGINS_HELM" -f ./values-dp.yaml -n kong-enterprise --version 2.3.0

else
  helm install kong-enterprise kong/kong  --set ingressController.installCRDs=false --set env.plugins="$DEMO_ENABLED_PLUGINS_HELM" --set env.vitals_strategy="$DEMO_VITALS_STRATEGY" -f ./values.yaml -n kong-enterprise --version 2.3.0
fi

echo -e "Checking if Kong has started..."
while true
do
    STATUS_CODE=$(curl --max-time 1 -s -o /dev/null -w "%{http_code}" http://localhost:9001/status)
    if [ $STATUS_CODE -eq 200 ]; then
        echo -e "OK"
        break
    else
        echo -e "Not yet. Got status: $STATUS_CODE"
        sleep 5
    fi
done

echo -e "Now adding all the other components"

. ../shared/kubernetes_shared_install.sh

