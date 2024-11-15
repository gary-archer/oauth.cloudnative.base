#!/bin/bash

###################################
# A script to create a KIND cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"

kind delete cluster --name=example 2>/dev/null
kind create cluster --name=example --config='./cluster/cluster-configuration.yaml'
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi
