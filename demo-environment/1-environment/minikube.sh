#!/bin/bash
export DEMO_ENV=minikube
export ADMIN_HOST=$(minikube -p minikube-kong-enterprise ip)
export PROXY_HOST=$ADMIN_HOST
export PROXY_SSL_HOST=$ADMIN_HOST
export MANAGER_HOST=$ADMIN_HOST
export PORTAL_HOST=$ADMIN_HOST
export PORTAL_ADMIN_HOST=$ADMIN_HOST

export ADMIN_PORT=31001
export PROXY_PORT=31000
export PROXY_SSL_PORT=31443
export MANAGER_PORT=31002
export PORTAL_PORT=31003
export PORTAL_ADMIN_PORT=31004



if [ "$ENABLE_ELK" = true ]
then
  export KIBANA_HOST=$ADMIN_HOST
  export KIBANA_PORT=31110
fi

if [ "$ENABLE_GRAYLOG" = true ]
then
  export GRAYLOG_HOST=$ADMIN_HOST
  export GRAYLOG_PORT=31110
fi

if [ "$ENABLE_SPLUNK" = true ]
then
  export SPLUNK_HOST=$ADMIN_HOST
  export SPLUNK_PORT=31105
  export SPLUNK_ADMIN_PORT=31106
fi

if [ "$ENABLE_UPSTREAM_TLS" = true ] ; 
then
  export UPSTREAM_TLS_HOST=$ADMIN_HOST
  export UPSTREAM_TLS_GUI_PORT=31903
  export UPSTREAM_TLS_BACKEND_PORT=31905
fi

if [ "$ENABLE_OPA" = true ] ; 
then
  export OPA_HOST=$ADMIN_HOST
  export OPA_PORT=31303
fi

if [ "$ENABLE_ZIPKIN" = true ] ; 
then
  export ZIPKIN_HOST=$ADMIN_HOST
  export ZIPKIN_PORT=31141
fi
