#!/bin/bash

###################################
# A script to delete an EKS cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Set parameters
#
CLUSTER_NAME='example'
AWS_ACCOUNT_ID='090109105180'
AWS_REGION='eu-west-2'
EBS_POLICY_NAME='EBSCSIDriverIAMPolicy'
LBC_POLICY_NAME='AWSLoadBalancerControllerIAMPolicy'

#
# Delete IAM policies
#
POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName==\`$EBS_POLICY_NAME\`].Arn" --output text)
if [ "$POLICY_ARN" == '' ]; then
  aws iam delete-policy --policy-arn $POLICY_ARN
fi

POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName==\`$LBC_POLICY_NAME\`].Arn" --output text)
if [ "$POLICY_ARN" == '' ]; then
  aws iam delete-policy --policy-arn $POLICY_ARN
fi

#
# Delete pod disruption budgets to prevent a blocked uninstall
#
kubectl -n kube-system delete poddisruptionbudget/coredns
kubectl -n kube-system delete poddisruptionbudget/ebs-csi-controller

#
# Finally delete the cluster
#
eksctl delete cluster --name example
