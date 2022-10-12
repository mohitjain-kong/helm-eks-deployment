#!/bin/bash
kumactl install observability | kubectl delete -f -
kumactl install observability | kubectl apply -f -
kubectl annotate service grafana ingress.kubernetes.io/service-upstream='true' -n mesh-observability
kubectl apply -f ../../../7-hosted-demo/gateway/ingress/grafana-mesh.yaml 
