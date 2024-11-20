#!/bin/bash

###################################
# A script to delete an EKS cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Set parameters
#
CLUSTER_NAME='example'
EBS_POLICY_NAME='EBSCSIDriverIAMPolicy'
LBC_POLICY_NAME='AWSLoadBalancerControllerIAMPolicy'

#
# If required, delete pod disruption budgets returned from the following command, to prevent a blocked uninstall
# - kubectl get poddisruptionbudget -A
#
kubectl -n kube-system delete poddisruptionbudget/coredns
kubectl -n kube-system delete poddisruptionbudget/ebs-csi-controller
kubectl -n ingress-nginx delete poddisruptionbudget/ingress-nginx-controller

#
# Finally delete the cluster
#
eksctl delete cluster --name $CLUSTER_NAME

#
# Delete IAM policies
#
POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName==\`$EBS_POLICY_NAME\`].Arn" --output text)
if [ "$POLICY_ARN" != '' ]; then
  aws iam delete-policy --policy-arn $POLICY_ARN
fi

POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName==\`$LBC_POLICY_NAME\`].Arn" --output text)
if [ "$POLICY_ARN" != '' ]; then
  aws iam delete-policy --policy-arn $POLICY_ARN
fi
