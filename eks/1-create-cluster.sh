#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Set parameters
#
CLUSTER_NAME='example'
AWS_ACCOUNT_ID='090109105180'
AWS_REGION='eu-west-2'

#
# Create the EKS cluster
#
eksctl delete cluster --name $CLUSTER_NAME 2>/dev/null
eksctl create cluster -f ./cluster/cluster-configuration.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi

#
# Associate the EKS built-in IAM OIDC provider to the cluster as the simplest way to enable IAM roles for service accounts
#
eksctl utils associate-iam-oidc-provider --region=$AWS_REGION --cluster=$CLUSTER_NAME --approve
if [ $? -ne 0 ]; then
  echo '*** Problem encountered associating the IAM OIDC provider with the cluster'
  exit 1
fi
