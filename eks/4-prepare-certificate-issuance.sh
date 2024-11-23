#!/bin/bash

###############################################################################################
# Set up an AWS role with permissions to allow access to AWS Route 53 and use the DNS01 solver.
# Then install cert-manager and associate it to that role.
# - https://cert-manager.io/docs/configuration/acme/dns01/route53/
###############################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

export CLUSTER_NAME='example'
export AWS_ACCOUNT_ID='090109105180'
export AWS_REGION='eu-west-2'
export ROLE_NAME='cert-manager'
export POLICY_NAME='CertManagerRoute53IAMPolicy'
export SERVICE_ACCOUNT_NAME='cert-manager-sa'

#
# First get the OIDC issuer hash
#
export EKS_HASH=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
if [ "$EKS_HASH" == '' ]; then
  echo '*** Unable to find the OIDC issuer hash'
  exit 1
fi

#
# Create the final trust policy
#
envsubst < ./resources/route53-trust-template.json > ./resources/route53-trust.json
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cert-manager role trust relationship'
  exit 1
fi

#
# Then create a role with the trust policy
#
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://resources/route53-trust.json
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cert-manager role'
  exit 1
fi

#
# Then create an inline policy to grant cert-manager access to route 53
#
aws iam create-policy \
  --policy-name $POLICY_NAME \
  --policy-document file://resources/route53-policy.json
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the AWS load balancer controller policy'
  exit 1
fi

#
# Attach the policy to the role to apply permissions
#
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/$POLICY_NAME
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cert-manager route 53 policy'
  exit 1
fi

#
# Recreate the cert-manager namespace if required
#
kubectl delete namespace cert-manager 2>/dev/null

#
# Install cert-manager resources
#
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager -n cert-manager --values=./resources/certmanager-helm-values.yaml --create-namespace
if [ $? -ne 0 ]; then
  echo '*** Problem encountered installing cert-manager'
  exit 1
fi

#
# Wait for services to be ready and allow a grace period to prevent validating web hook errors
#
echo 'Waiting for cert-manager pods to come up ...'
kubectl wait pod --for=condition=ready -n cert-manager -l app=cert-manager
sleep 30

#
# Create a cluster issuer for the API gateway's host names
#
kubectl apply -f ./resources/cluster-issuer.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cluster issuer for the gateway SSL certificate'
  exit 1
fi
