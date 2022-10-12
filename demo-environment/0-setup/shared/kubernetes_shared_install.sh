#!/bin/bash

if [ "$ENABLE_TWO_ADDITIONAL_NODES" = true ] ; 
then
  echo -e "[FEATURE] Scaling out to three nodes in sum"
  
  if [ "$ENABLE_HYBRID_MODE" = "true" ] ; 
  then
    echo -e "ENABLE_HYBRID_MODE enabled"
    kubectl scale --replicas=3 deployment/kong-enterprise-dataplanes-kong -n kong-enterprise

  else
    kubectl scale --replicas=3 deployment/kong-enterprise-kong -n kong-enterprise
  fi
fi

if [ "$ENABLE_REDIS" = true ] ; 
then
  kubectl create -f ../shared/Databases/redis.yaml -n databases
fi

if [ "$ENABLE_INFLUXDB" = true ] ; 
then
  kubectl create -f ../shared/Databases/influx.yaml -n databases
fi

if [ "$ENABLE_KONGMAP" = true ] ; 
then
  kubectl create -f ../shared/Kong/kongmap.yaml -n kong-enterprise
fi

if [ "$ENABLE_PROMETHEUS_GRAFANA" = true ] ; 
then
  kubectl apply -f ../shared/Monitoring/prometheus/clusterRole.yaml 
  kubectl apply -f ../shared/Monitoring/prometheus/prometheus-config-map.yaml -n monitoring
  kubectl create configmap grafana-dashboard-config --from-file=../shared/Monitoring/cfg/grafana/dashboards/dashboards.yml --from-file=../shared/Monitoring/cfg/grafana/dashboards/kong  -n monitoring
  kubectl create configmap grafana-datasources-config --from-file=../shared/Monitoring/cfg/grafana/datasources  -n monitoring
  kubectl apply -f ../shared/Monitoring/prometheus_grafana.yaml -n monitoring
fi

if [ "$ENABLE_GRAYLOG" = "true" ] ; 
then
  export ENABLE_ELK="true"
  kubectl apply -f ../shared/Monitoring/graylog.yaml -n monitoring
  kubectl apply -f ../shared/Databases/mongodb.yaml -n Databases
fi

if [ "$ENABLE_ELK" = true ] ; 
then
  kubectl create configmap efk-config --from-file=../shared/Monitoring/cfg/elk/ -n monitoring
  kubectl apply -f ../shared/Monitoring/elk/elk.yaml -n monitoring
  if [ "$ENABLE_KONG_MESH" = "true" ] ; 
  then
    kubectl create configmap filebeat-mesh-config --from-file=../shared/Monitoring/cfg/filebeat-mesh/ -n monitoring
    kubectl apply -f ../shared/Monitoring/elk/filebeat-mesh.yaml -n monitoring
  fi
fi

if [ "$ENABLE_SPLUNK" = true ] ; 
then
  kubectl apply -f ../shared/Monitoring/splunk.yaml -n monitoring
fi

if [ "$ENABLE_SYSLOG" = true ] ; 
then
  kubectl apply -f ../shared/Monitoring/syslog.yaml -n monitoring
fi

if [ "$ENABLE_DATADOG" = true ] ; 
then
  kubectl apply -f ../shared/Monitoring/datadog.yaml -n monitoring
fi

if [ "$ENABLE_OPA" = true ] ; 
then
  kubectl apply -f ../shared/IDP/opa.yaml -n idp
fi

if [ "$ENABLE_GRPC" = true ] ; 
then
  kubectl apply -f ../shared/Backends/grpcbin.yaml -n monitoring
fi

if [ "$ENABLE_ZIPKIN" = true ] ; 
then
  kubectl apply -f ../shared/Tracing/zipkin.yaml -n tracing
  kubectl apply -f ../shared/Tracing/tracing-frontend.yaml -n tracing
  kubectl apply -f ../shared/Tracing/tracing-backend.yaml -n tracing
fi

echo -e "\n*** Creating example backend services"
kubectl create -f ../shared/Backends/httpbin.yaml -n backends
kubectl create -f ../shared/Backends/anotherHttpbin.yaml -n backends
kubectl create -f ../shared/Backends/jsonplaceholder.yaml -n backends

if [ "$ENABLE_KONG_MESH" = "true" ] ; 
then
  echo -e "[FEATURE] Kong Mesh"
  kubectl apply -f ../shared/Mesh/mesh_defaults.yaml
  echo -e "Adding example ingress"
  kubectl create -f ../shared/Backends/httpbin.yaml -n mesh-demo
  kubectl apply -f ../../2-create-contents/subScripts/ingress-controller/httpbin-in-mesh-ingress.yaml
fi

if [ "$ENABLE_BANKONG" = "true" ] ; 
then
  echo -e "[FEATURE] BanKonG"
  kubectl apply -f ../shared/Mesh/bankong.yaml -n bankong
fi
