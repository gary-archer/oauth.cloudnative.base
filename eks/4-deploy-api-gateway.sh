#!/bin/bash

#################################################################################
# Deploy the API gateway with a load balancer that uses an external IP address
#- https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md#aws
#################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Get the ID of a preconfigured Elastic IP address of 18.168.121.141
#
EXTERNAL_IP_NAME='wordpress'
EXTERNAL_IP_ALLOCATION_ID=$(aws ec2 describe-addresses --filters "Name=tag:Name,Values=$EXTERNAL_IP_NAME" --query "Addresses[].AllocationId" --output text)
if [ "$EXTERNAL_IP_ALLOCATION_ID" == '' ]; then
  echo '*** Unable to find the allocation ID for the Elastic IP address'
  exit 1
fi

#
# Get the ID of the public subnet for the AWS availability zone where the cluster runs
#
SUBNET_NAME='eksctl-example-cluster/SubnetPublicEUWEST2A'
SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SUBNET_NAME" --query "Subnets[].SubnetId" --output text)
if [ "$SUBNET_ID" == '' ]; then
  echo '*** Unable to find the subnet ID for the AWS load balancer'
  exit 1
fi

#
# Create the final gateway-values.yaml file with the runtime subnet ID
#
export EXTERNAL_IP_ALLOCATION_ID
export SUBNET_ID
envsubst < ./gateway/helm-values-template.yaml > ./gateway/helm-values.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating the Helm gateway values file'
  exit 1
fi

#
# Create a cluster issuer for the API gateway's host names, so that ingress resources can be created in any namespace
#
kubectl apply -f gateway/cluster-issuer.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cluster issuer for the gateway SSL certificate'
  exit 1
fi

#
# Deploy the NGINX ingress controller and use an AWS network load balancer
#
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values=./gateway/helm-values.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the ingress controller'
  exit 1
fi

#
# Wait for NGINX
#
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

#
# When using this deployment I configure AWS Route 53 to point wordpress.authsamples-k8s.com to the Elastic IP
# After a couple of minutes the following command confirms that mapping
# - dig wordpress.authsamples-k8s.com
#
