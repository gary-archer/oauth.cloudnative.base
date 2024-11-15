#!/bin/bash

##########################################################################################################################
# Deploy the AWS Load Balancer Controller and use IAM roles for service accounts to enable it to create EC2 load balancers
# - https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation
##############################################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Set parameters
#
CLUSTER_NAME='example'
AWS_ACCOUNT_ID='090109105180'
AWS_REGION='eu-west-2'
POLICYNAME='AWSLoadBalancerControllerIAMPolicy'

#
# Create an IAM inline policy to grant the load balancer controller EC2 load balancing permissions
# https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.10.0/docs/install/iam_policy.json
#
aws iam create-policy \
  --policy-name $POLICYNAME \
  --policy-document file://iam-policies/lbc-policy.json
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the AWS load balancer controller policy'
  exit 1
fi

#
# Next create a service account linked to the AWS policy
#
eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::$AWS_ACCOUNT_ID:policy/$POLICYNAME \
  --override-existing-serviceaccounts \
  --region $AWS_REGION \
  --approve
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the IAM service account for the AWS load balancer controller'
  exit 1
fi

#
# Install the AWS load balancer controller which can watch ingress resources and create EC2 load balancers
#
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
if [ $? -ne 0 ]; then
  echo '*** Problem encountered installing AWS load balancer controller'
  exit 1
fi
