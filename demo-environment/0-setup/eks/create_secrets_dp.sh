#!/bin/bash

echo -e "\n*** Creating CP namespace"
kubectl create namespace kong-hybrid-dp


echo -e "\n*** Creating secret for license"
# kubectl create secret generic kong-enterprise-license --from-file=license=./license -n kong-hybrid-dp


echo -e "\n*** Create a secret containing the certificates for the Control Plane"
kubectl create secret tls kong-cluster-cert --cert=cluster.crt --key=cluster.key -n kong-hybrid-dp

kubectl create secret tls kong-cluster-cert-upstream --cert=./hybrid/cluster.crt --key=./hybrid/cluster.key -n kong-hybrid-dp