#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

##################################################################################################
# Deploy the EBS CSI driver and use IAM roles for service accounts to enable it to use EC2 volumes
##################################################################################################

#
# Set parameters
#
CLUSTER_NAME='example'
AWS_ACCOUNT_ID='090109105180'
AWS_REGION='eu-west-2'
POLICYNAME='EBSCSIDriverIAMPolicy'

#
# Create an IAM inline policy to grant the load balancer controller EC2 load balancing permissions
# https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.10.0/docs/install/iam_policy.json
#
aws iam create-policy \
  --policy-name $POLICYNAME \
  --policy-document file://iam-policies/ebs-policy.json
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
  --name=ebs-csi-controller-sa \
  --attach-policy-arn=arn:aws:iam::$AWS_ACCOUNT_ID:policy/$POLICYNAME \
  --override-existing-serviceaccounts \
  --region $AWS_REGION \
  --approve
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the IAM service account for the EBS CSI driver'
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
if [ $? -ne 0 ]; then
  echo '*** Problem encountered deploying the EBS CSI driver'
  exit 1
fi

#
# Create a custom storage class to use EBS with gp3
#
kubectl apply -f cluster/custom-storageclass.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered deploying the custom storage class'
  exit 1
fi