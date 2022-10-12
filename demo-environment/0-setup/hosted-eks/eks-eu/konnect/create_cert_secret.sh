#!/bin/bash
kubectl create secret tls kong-cluster-cert --cert=./tls.crt --key=./tls.key -n konnect
