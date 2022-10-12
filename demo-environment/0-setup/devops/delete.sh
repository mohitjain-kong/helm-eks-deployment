#!/bin/bash
source ~/.demo-env/.devops_details.sh
http --verify=no https://ops.kong-sales-engineering.com/ops/kill cluster==$DEVOPS_CLUSTER_NAME zone==$DEVOPS_ZONE -a $DEVOPS_USERNAME:$DEVOPS_PASSWORD

