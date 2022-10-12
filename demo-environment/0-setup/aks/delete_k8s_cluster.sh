#!/bin/bash
echo -e "\n*** Deleting cluster (this will take a while...)"
az aks delete -g DemoEnv -n DemoEnv
