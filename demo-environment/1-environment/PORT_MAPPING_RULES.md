# Port mapping rules

As every environment has it's own selection of ports we should addict to a standard on how to use them (if we can configure them).

## General rule

The overall rule shall be

xx00y: Kong related ports (for example 8000 and 8001)
xx01y: Additional Kong ports (for example 8010 on additional nodes)
xx02y: Additional Kong ports (for example 8020 on additional nodes)
xx03y: Immunury related
xx4xx: SSL Ports
xx8yy: Mesh related
xx1yy: Monitoring (for example 8100 Grafana)
xx2yy: More Monitoring
xx3yy: IDPs (for example 8300 local Keycloak)
xx8yy: Databases
xx9yy: Backends (for example 8900 GRPC)

One system shall always use the same port on any environment, for example Grafana:

*  8100 on docker-compose
*  9100 on k3d
* 31100 on Minikube
* ...

## Kong ports (xx00y, xx01y and xx44y)

* xx000: Proxy
* xx001: Admin-API
* xx002: Manager
* xx003: Portal
* xx004: Portal-API
* xx005: Hybrid cluster control plane
* xx007: Stream TCP
* xx008: Stream UDP
* xx009: Kongmap
* xx011: Status listen
* xx017: UDP listen
* xx018: Stream listen
* xx019: Stream listen
* xx027: UDP listen
* xx028: Stream listen
* xx029: Stream listen
* xx443: Proxy
* xx444: Admin-API TLS
* xx445: Manager TLS
* xx446: Portal TLS
* xx447: Portal-API TLS
* xx448: Hybrid cluster control plane TLS

## Mesh

* xx800: Mesh API and GUI
* xx801: Ingress
* xx802: Global control plane listen

## Monitoring

* xx100: Grafana
* xx101: Prometheus
* xx110: Kibana (EFK)
* xx111: Elasticsearch
* xx112: Filebeat
* xx120: Splunk
* xx121: Splunk (listener)
* xx122: Splunk (admin)
* xx130: Syslog (Pimp my logs) 
* xx140: Graylog
* xx141: Zipkin

## IDP

* xx300: local Keycloak
* xx301: OpenLDAP
* xx302: OpenLDAP gui
* xx303: OPA

## Anything else

* xx500: AsyncAPI Studio

## Databases

* xx800: Postgres

## Backends

* xx900: GRPC
* xx901: GPRC
* xx902: Kafka / Zookeeper
* xx903: Upstream TLS gui
* xx904: Upstream TLS
* xx905: Websocket
