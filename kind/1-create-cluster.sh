#!/bin/bash

###################################
# A script to create a KIND cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"

CLUSTER_NAME=example
kind delete cluster --name=$CLUSTER_NAME 2>/dev/null
kind create cluster --name=$CLUSTER_NAME --config='./resources/cluster-configuration.yaml'
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi
