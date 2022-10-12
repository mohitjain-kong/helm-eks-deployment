if [ "$ENABLE_KONG_MESH" = "true" ] || [ "$ENABLE_KONG_MESH_REMOTE" = "true" ] ; 
then
  echo -e "[FEATURE] Kong Mesh"
  helm repo add kong-mesh https://kong.github.io/kong-mesh-charts
  kubectl create secret generic kong-mesh-license -n kong-mesh-system --from-file=../shared/Kong/license.json
  helm repo update
  if [ "$ENABLE_KONG_MESH_REMOTE" = "true" ] ; 
  then
    echo -e "***************************************"
    echo -e "!!! JOINING AN EXISTING MULTIZONE MESH"
    echo -e "1) Please make sure to have the latest kumactl version for Kong Mesh installed"
    echo -e "2) Please enter the global remote url - for example grpcs://1.2.3.4:5685"
    read global_control_plane
    echo -e "3) Please provide the token to access control plane (this remote zone will be named local-laptop)"
    echo -e "How to get the token on the global(!) control plane:"
    echo -e " kumactl generate control-plane-token --zone=local-laptop"
    echo -e "Copy and paste the token now here:"
    read control_plane_token
    helm upgrade -f ../shared/Mesh/values.yaml -i -n kong-mesh-system kong-mesh --set kuma.controlPlane.mode=zone,kuma.controlPlane.zone=local-laptop,kuma.ingress.enabled=true,kuma.controlPlane.kdsGlobalAddress=$global_control_plane,kuma.controlPlane.envVars.KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE="$control_plane_token" kong-mesh/kong-mesh
  else
    helm upgrade -f ../shared/Mesh/values.yaml -i -n kong-mesh-system kong-mesh kong-mesh/kong-mesh
    # kubectl apply -f ../shared/Mesh/demo-app-owner.yaml -f ../shared/Mesh/zones_admin.yaml
  fi
fi
