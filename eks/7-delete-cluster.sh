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
ROLE_NAME='cert-manager'
EBS_POLICY_NAME='EBSCSIDriverIAMPolicy'
LBC_POLICY_NAME='AWSLoadBalancerControllerIAMPolicy'
CM_POLICY_NAME='CertManagerRoute53IAMPolicy'

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
# Delete the cert-manager IAM role
#
aws iam detach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/$CM_POLICY_NAME
aws iam delete-role --role-name $ROLE_NAME

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

POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName==\`$CM_POLICY_NAME\`].Arn" --output text)
if [ "$POLICY_ARN" != '' ]; then
  echo 'deleting policy'
  aws iam delete-policy --policy-arn $POLICY_ARN
fi
