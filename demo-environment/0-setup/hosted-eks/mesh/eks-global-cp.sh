#!/bin/sh
kumactl install control-plane \
--mode=global \
--license-path=../../shared/Kong/license.json | kubectl apply -f -

