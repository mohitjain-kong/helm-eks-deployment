#!/bin/bash
eksctl utils associate-iam-oidc-provider --region=eu-central-1 --cluster=kong-se-central-demo --approve
eksctl create iamserviceaccount \
  --name external-dns \
  --namespace default \
  --cluster kong-se-central-demo \
  --attach-policy-arn arn:aws:iam::162225303348:policy/ExternalDNS \
  --approve \
  --override-existing-serviceaccounts

