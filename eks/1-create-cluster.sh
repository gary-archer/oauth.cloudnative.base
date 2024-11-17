#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Set parameters
#
CLUSTER_NAME='example'

#
# Create an EKS cluster with the worker nodes in a single availability zone, to simplify infrastructure
#
eksctl delete cluster --name $CLUSTER_NAME 2>/dev/null
eksctl create cluster -f ./cluster/cluster-configuration.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi
