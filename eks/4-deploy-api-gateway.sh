#!/bin/bash

#################################################################################
# Deploy the API gateway with a load balancer that uses an external IP address
#- https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md#aws
#################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# First install cert-manager so that the API gateway can request an SSL certificate for its host names
#
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered getting cert-manager resources'
  exit 1
fi

#
# Wait for certmanager pods to come up
#
kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

#
# Create a cluster issuer for the API gateway's host names, so that ingress resources can be created in any namespace
#
kubectl apply -f ./resources/cluster-issuer.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cluster issuer for the gateway SSL certificate'
  exit 1
fi

#
# I precreated and tagged an Elastic IP address of 18.168.121.141 to represent the API gateway's external IP address
#
EXTERNAL_IP_NAME='wordpress'
EXTERNAL_IP_ALLOCATION_ID=$(aws ec2 describe-addresses --filters "Name=tag:Name,Values=$EXTERNAL_IP_NAME" --query "Addresses[].AllocationId" --output text)
if [ "$EXTERNAL_IP_ALLOCATION_ID" == '' ]; then
  echo '*** Unable to find the allocation ID for the Elastic IP address'
  exit 1
fi

#
# Get the ID of the public subnet for the AWS availability zone where the cluster runs, which has a fixed name
#
SUBNET_NAME='eksctl-example-cluster/SubnetPublicEUWEST2A'
SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SUBNET_NAME" --query "Subnets[].SubnetId" --output text)
if [ "$SUBNET_ID" == '' ]; then
  echo '*** Unable to find the subnet ID for the AWS load balancer'
  exit 1
fi

#
# Create the final nginx-helm-values.yaml file from the calculated IDs
#
export EXTERNAL_IP_ALLOCATION_ID
export SUBNET_ID
envsubst < ./resources/nginx-helm-values-template.yaml > ./resources/nginx-helm-values.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating the NGINX Helm values file'
  exit 1
fi

#
# Deploy the NGINX ingress controller and an AWS network load balancer that passes layer 4 traffic to it
#
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values=./resources/nginx-helm-values.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the ingress controller'
  exit 1
fi

#
# In AWS Route 53 I created an A record for wordpress.authsamples-k8s.com that points to the external IP address:
# - dig wordpress.authsamples-k8s.com
#
