#!/bin/bash
echo -e "\n*** Creating EKS cluster (will take a long time....)"
eksctl create cluster --profile default -f cluster.yaml    
