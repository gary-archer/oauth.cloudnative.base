#!/bin/bash

#################################################################################
# Deploy the API gateway with a load balancer that uses an external IP address
#- https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md#aws
#################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

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
# First create the namespace
#
kubectl delete namespace ingress-nginx 2>/dev/null
kubectl create namespace ingress-nginx
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the NGINX namespace'
  exit 1
fi

#
# Ask cert-manager to create a certificate that points to an external-tls secret for the API gateway's domain names
#
kubectl -n ingress-nginx apply -f ./resources/external-certificate.yaml
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating the certificate for the API gateway'
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
