#!/bin/bash

##################################
# Tear down the Kubernetes cluster
##################################

cd "$(dirname "${BASH_SOURCE[0]}")"
kind delete cluster --name=nodeha 2>/dev/null
