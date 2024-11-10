#!/bin/bash

###################################
# A script to delete an EKS cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"

kubectl -n kube-system delete poddisruptionbudget/coredns
kubectl -n kube-system delete poddisruptionbudget/ebs-csi-controller
eksctl delete cluster --name example
