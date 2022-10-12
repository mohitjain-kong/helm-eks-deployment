#!/bin/bash
echo -e "\n*** Deleting cluster (this will take a while...)"
eksctl delete cluster -f cluster.yaml
