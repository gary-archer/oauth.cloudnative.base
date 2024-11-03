#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create an EKS cluster
#
eksctl delete cluster --name example 2>/dev/null
eksctl create cluster -f ./cluster/cluster-configuration.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi

#
# Install the EBS CSI driver
#
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver
 
#
# Create a custom storage class to use EBS with gp3
#
kubectl apply -f cluster/custom-storageclass.yaml
