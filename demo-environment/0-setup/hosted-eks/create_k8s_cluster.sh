#!/bin/bash
echo -e "\n*** Creating EKS cluster for main workload (will take a long time....)"
eksctl create cluster -f cluster.yaml    
echo -e "\n*** Creating EKS cluster for global control plane (will take a long time....)"
eksctl create cluster -f global_control_plane_cluster.yaml
