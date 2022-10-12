#!/bin/bash

echo -e "\n*** Creating CP namespace"
kubectl create namespace kong-hybrid-cp


echo -e "\n*** Creating secret for sessions"
kubectl create secret generic kong-session-conf --from-file=admin_gui_session_conf --from-file=portal_session_conf -n kong-hybrid-cp

echo -e "\n*** Creating secret for license"
kubectl create secret generic kong-enterprise-license --from-file=license=./license -n kong-hybrid-cp

echo -e "\n*** Create a secret containing the password for the Super-Admin user which can be used to login into Kong Manager and the Admin API"
kubectl create secret generic kong-enterprise-superuser-password -n kong-hybrid-cp --from-literal=password=password

echo -e "\n*** Create a secret containing the certificates for the Control Plane"
kubectl create secret tls kong-cluster-cert --cert=cluster.crt --key=cluster.key -n kong-hybrid-cp

