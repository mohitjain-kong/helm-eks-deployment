#!/bin/bash
export DEMO_ENV=hosted-eks
export ADMIN_HOST=admin.service-connectivity.com
export PROXY_HOST=proxy.service-connectivity.com
export UDP_HOST=idp.service-connectivity.com
export MANAGER_HOST=manager.service-connectivity.com
export PORTAL_HOST=portal.service-connectivity.com
export PORTAL_ADMIN_HOST=portal-api.service-connectivity.com
export ADMIN_PORT=80
export PROXY_PORT=80
export PROXY_SSL_PORT=443
export UDP_PORT=80
#export HTTP2_PROXY_PORT=9080
#export HTTP2_PROXY_SSL_PORT=9081
export MANAGER_PORT=80
export PORTAL_PORT=80
export PORTAL_ADMIN_PORT=80

if [ "$ENABLE_PROMETHEUS_GRAFANA" = true ]
then
  export GRAFANA_HOST=grafana.service-connectivity.com
  export GRAFANA_PORT=80
  export PROMETHEUS_HOST=prometheus.service-connectivity.com
  export PROMETHEUS_PORT=80
fi

if [ "$ENABLE_ELK" = true ]
then
  export KIBANA_HOST=kibana.service-connectivity.com
  export KIBANA_PORT=80
fi

if [ "$ENABLE_GRAYLOG" = true ]
then
  export GRAYLOG_HOST=graylog.service-connectivity.com
  export GRAYLOG_PORT=80
fi

if [ "$ENABLE_SYSLOG" = true ]
then
  export SYSLOG_HOST=syslog.service-connectivity.com
  export SYSLOG_PORT=80
fi

if [ "$ENABLE_KONGMAP" = true ]
then
  export KONGMAP_HOST=kongmap.service-connectivity.com
  export KONGMAP_PORT=80
fi

if [ "$ENABLE_SPLUNK" = true ]
then
  export SPLUNK_HOST=splunk.service-connectivity.com
  export SPLUNK_PORT=80
  export SPLUNK_ADMIN_PORT=8122
fi


if [ "$ENABLE_UPSTREAM_TLS" = true ] ; 
then
  export UPSTREAM_TLS_HOST=upstream-tls.service-connectivity.com
  export UPSTREAM_TLS_GUI_PORT=443
  export UPSTREAM_TLS_BACKEND_PORT=8443
fi

if [ "$ENABLE_OPA" = true ] ; 
then
  export OPA_HOST=opa.service-connectivity.com
  export OPA_PORT=80
fi

if [ "$ENABLE_ZIPKIN" = true ] ; 
then
  export ZIPKIN_HOST=zipkin.service-connectivity.com
  export ZIPKIN_PORT=80
fi
