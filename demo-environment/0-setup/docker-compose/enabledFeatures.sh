#!/bin/bash
ADDITIONAL_COMPONENTS=""

if [ "$ENABLE_TWO_ADDITIONAL_NODES" = true ] ; 
then
  if [ "$ENABLE_HYBRID_MODE" = "true" ] ; 
  then
    echo -e "[DISABLED][FEATURE] Scaling out not available in hybrid mode (already two dp nodes running)"
    # no scaling in this case
  else
    echo -e "[FEATURE] Scaling out to three nodes in sum"
    ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/kong-additional-nodes.yaml"
  fi
fi

if [ "$ENABLE_BETA_3" = true ] ; 
then
  echo -e "[FEATURE] BETA 3.0.0 AMD64 image enabled  - This will pull the image on every (re)start!"
  docker pull kong/kong-gateway-internal:master
  export env_file=beta3.env
fi

if [ "$ENABLE_BETA_ARM" = true ] ; 
then
  echo -e "[FEATURE] BETA ARM image enabled - This will pull the image on every (re)start!"
  docker pull kong/kong-gateway-internal:alpine-arm-image-alpine
  export env_file=arm.env
fi

if [ "$ENABLE_OPENLDAP" = true ] ; 
then
  echo -e "[FEATURE] OpenLDAP enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/openldap.yaml"
fi

if [ "$ENABLE_BANKONG" = true ] ; 
then
  echo -e "[FEATURE] BanKonG enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/bankong.yaml"
fi

if [ "$ENABLE_REDIS" = true ] ; 
then
  echo -e "[FEATURE] Redis enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/redis.yaml"
fi

if [ "$ENABLE_INFLUXDB" = true ] ; 
then
  echo -e "[FEATURE] InfluxDB enabled"
  export DEMO_VITALS_STRATEGY=influxdb
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/influx.yaml"
else
  unset DEMO_VITALS_STRATEGY
fi

if [ "$ENABLE_KONGMAP" = true ] ; 
then
  echo -e "[FEATURE] Kongmap enabled"
  if [[ $(uname -m) == 'arm64' ]]; then
    echo -e "⚠️⚠️⚠️ Kongmap seems to have issues on Apple Silicon M1 Rosetta emulation."
  fi
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/kongmap.yaml"
fi

if [ "$ENABLE_LOCAL_KEYCLOAK" = "true" ] ; 
then
  echo -e "[FEATURE] Local Keycloak enabled"
  export KEYCLOAK_DATA_FOLDER=~/.demo-env/keycloak
  if [ -d "$KEYCLOAK_DATA_FOLDER" ]
  then
    echo -e "Deleting old Keycloak data folder"
    rm -Rf $KEYCLOAK_DATA_FOLDER
  fi
  echo -e "Copying Keycloak database data"
  mkdir -p $KEYCLOAK_DATA_FOLDER/data
  cp -a cfg/keycloak/data/* $KEYCLOAK_DATA_FOLDER/data/
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/keycloak.yaml"
fi

if [ "$ENABLE_UPSTREAM_TLS" = true ] ; 
then
  echo -e "[FEATURE] Upstream TLS enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/upstreamTLS.yaml"
fi

if [ "$ENABLE_TCP_STREAM" = true ] ; 
then
  echo -e "[FEATURE] TCP example backend"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/tcpbackend.yaml"
fi

if [ "$ENABLE_OPA" = true ] ; 
then
  echo -e "[FEATURE] OPA"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/opa.yaml"
fi

if [ "$ENABLE_DATADOG" = true ] ; 
then
  echo -e "[FEATURE] DataDog enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/datadog.yaml"

  if [ -f ~/.demo-env/vars ]; 
  then
    echo -e "Found ~/.demo-env/vars - sourcing it\n"
    . ~/.demo-env/vars 
  fi

  if [ -z "$DD_API_KEY" ]
  then
    echo -e "Datadog API Key: "
    read DD_API_KEY
    export DD_API_KEY
  fi
fi

if [ "$ENABLE_ELK" = true ]
then
  echo -e "[FEATURE] ELK enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/elk_stack.yaml"
fi

if [ "$ENABLE_GRAYLOG" = true ]
then
  echo -e "[FEATURE] Graylog enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/graylog.yaml"
fi

if [ "$ENABLE_SPLUNK" = true ]
then
  echo -e "[FEATURE] Splunk enabled"
  if [[ $(uname -m) == 'arm64' ]]; then
    echo -e "⚠️⚠️⚠️ Sorry but Splunk is not available on Apple Silicon M1 as of today and does not even run in Rosetta emulation. Disabling the feature"
    unset ENABLE_SPLUNK
  else
    ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/splunk.yaml"
  fi
fi


if [ "$ENABLE_PROMETHEUS_GRAFANA" = true ] ; 
then
  echo -e "[FEATURE] Prometheus and Grafana enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/prometheus_grafana.yaml"
fi

if [ "$ENABLE_GRPC" = true ] ; 
then
  echo -e "[FEATURE] gRPCbin enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/grpc.yaml"
fi

if [ "$ENABLE_WEBSOCKET" = true ] ; 
then
  echo -e "[FEATURE] websocket enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/websocket.yaml"
fi

if [ "$ENABLE_VAULT" = true ] ; 
then
  echo -e "[FEATURE] Vault enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/vault.yaml"
fi

if [ "$ENABLE_SYSLOG" = true ] ; 
then
  echo -e "[FEATURE] Syslog enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/syslog.yaml"
fi

if [ "$ENABLE_KAFKA" = true ] ;
then
  echo -e "[FEATURE] Kafka enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/kafka_zookeeper.yaml"
fi

if [ "$ENABLE_ZIPKIN" = true ] ;
then
  echo -e "[FEATURE] Zipkin Tracing enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/zipkin.yaml"
fi

if [ "$ENABLE_ASYNCAPI_STUDIO" = true ] || [ "$ENABLE_ASYNCAPI_PLAYGROUND" = true ] ;
then
  echo -e "[FEATURE] AsyncAPI Studio enabled"
  ADDITIONAL_COMPONENTS="$ADDITIONAL_COMPONENTS -f optional-features/asyncapi-studio.yaml"
fi

export ADDITIONAL_COMPONENTS
