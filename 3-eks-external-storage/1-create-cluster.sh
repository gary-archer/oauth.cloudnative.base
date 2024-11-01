#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create an EKS cluster
#
eksctl delete cluster -f ./cluster-configuration.yaml 2>/dev/null
eksctl create cluster -f ./cluster-configuration.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi
