#!/bin/sh
kumactl install control-plane \
--mode=zone \
--zone=eks-eu-central1 \
--ingress-enabled \
--kds-global-address grpcs://global-control-plane-grpcs.service-connectivity.com:5685 \
--cp-token-path=./eks-token | kubectl apply -f -

