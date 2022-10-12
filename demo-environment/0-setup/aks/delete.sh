#!/bin/bash
. ../../1-environment/aks.sh
. ../../1-environment/shared.sh
# Delete AKS cluster.
. ./delete_k8s_cluster.sh
# Delete Resource Group
. ./delete_resource_group.sh
# Unassign Public IP Addresses. Must be done after everything else has been deleted, else you get an error.
. ./delete_ip_addresses.sh