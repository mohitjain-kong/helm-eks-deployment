#!/bin/sh
kumactl install control-plane \
--mode=zone \
--zone=gke-us-central1 \
--ingress-enabled \
--kds-global-address grpcs://global-control-plane-grpcs.service-connectivity.com:5685 \
--cp-token-path=./gke-token | kubectl apply -f -

