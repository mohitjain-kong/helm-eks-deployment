#!/bin/bash
source ~/.demo-env/.devops_details.sh

export DEMO_ENV=devops
unset ENABLE_KONG_MESH
unset ENABLE_KONG_MESH_REMOTE
unset ENABLE_PROMETHEUS_GRAFANA
unset ENABLE_SYSLOG
unset ENABLE_ELK
unset ENABLE_SPLUNK
unset ENABLE_LOCAL_KEYCLOAK
unset ENABLE_SIGSCI


# the following vars are only created to stay in line with the other scripts
# devops already has all the _URL variables
export ADMIN_HOST=foo
export PROXY_HOST=$ADMIN_HOST
export UDP_HOST=$ADMIN_HOST
export MANAGER_HOST=$ADMIN_HOST
export PORTAL_HOST=$ADMIN_HOST
export PORTAL_ADMIN_HOST=$ADMIN_HOST
export ADMIN_PORT=9001
export PROXY_PORT=9000
export PROXY_SSL_PORT=9443
export MANAGER_PORT=9002
export PORTAL_PORT=9003
export PORTAL_ADMIN_PORT=9004


#if [ "$ENABLE_PROMETHEUS_GRAFANA" = true ]
#then
#  export GRAFANA_HOST=$ADMIN_HOST
#  export GRAFANA_PORT=9100
#  export PROMETHEUS_HOST=$ADMIN_HOST
#  export PROMETHEUS_PORT=9101
#fi

#if [ "$ENABLE_ELK" = true ]
#then
#  export KIBANA_HOST=$ADMIN_HOST
#  export KIBANA_PORT=9110
#fi

#if [ "$ENABLE_GRAYLOG" = true ]
#then
#  export GRAYLOG_HOST=$ADMIN_HOST
#  export GRAYLOG_PORT=9110
#fi

#if [ "$ENABLE_SYSLOG" = true ]
#then
#  export SYSLOG_HOST=$ADMIN_HOST
#  export SYSLOG_PORT=9130
#fi

#if [ "$ENABLE_KONGMAP" = true ]
#then
#  export KONGMAP_PORT=9009
#fi

#if [ "$ENABLE_SPLUNK" = true ]
#then
#  export SPLUNK_HOST=$ADMIN_HOST
#  export SPLUNK_PORT=9120
#  export SPLUNK_ADMIN_PORT=9122
#fi


#if [ "$ENABLE_UPSTREAM_TLS" = true ] ; 
#then
#  export UPSTREAM_TLS_HOST=$ADMIN_HOST
#  export UPSTREAM_TLS_GUI_PORT=9903
#  export UPSTREAM_TLS_BACKEND_PORT=9905
#fi

#if [ "$ENABLE_OPA" = true ] ; 
#then
#  export OPA_HOST=$ADMIN_HOST
#  export OPA_PORT=9303
#fi


echo -e "\n**** Kong configuration settings"
echo -e "Portal-Admin-API: $PORTAL_ADMIN_URL (setting KONG_PORTAL_API_URL)"
echo -e "Kong-Admin-API: $ADMIN_URL (setting KONG_ADMIN_API_URI)"
echo -e "Portal-Host: $PORTAL_HOST:$PORTAL_PORT (setting KONG_PORTAL_GUI_HOST)"

echo -e "**** Kong-Environment"
echo -e "Admin: $ADMIN_URL"
echo -e "Proxy: $PROXY_URL"
echo -e ""
echo -e "**** User interfaces URLs"
echo -e "Manager:      $MANAGER_URL"
echo -e "Portal:       $PORTAL_URL"
echo -e "Kong Mesh:    $MESH_URL"
echo -e "Grafana Mesh: $GRAFANA_MESH"