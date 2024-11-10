#!/bin/bash

#########################################################################################
# Deploy the AWS Load Balancer Controller so that ingress uses application load balancers
#########################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# I need to create a service account with policy permissions
# Use IAM roles for service accounts and get to know it better
# See if I can use it for EBS also
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/
#

#
# First, install the AWS load balancer controller to enable the use of the Application Load Balancer
#
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=example \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
if [ $? -ne 0 ]; then
  echo '*** Problem encountered installing AWS load balancer controller'
  exit 1
fi
