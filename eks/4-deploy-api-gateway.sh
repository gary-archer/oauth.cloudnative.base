#!/bin/bash

#################################################################################
# Deploy the API gateway with a load balancer that uses an external IP address
#- https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md#aws
#################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Point to a preconfigured Elastic IP address and calculate the subnet ID
#
EXTERNAL_IP_ADDRESS_REF='eipalloc-0a1580d8c176bda67'
SUBNET_NAME='eksctl-example-cluster/SubnetPublicEUWEST2A'
SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SUBNET_NAME" --query "Subnets[].SubnetId" --output text)
if [ "$SUBNET_ID" == '' ]; then
  echo '*** Unable to find the subnet ID for the AWS load balancer'
  exit 1
fi

#
# Create the final gateway-values.yaml file with the runtime subnet ID
#
export EXTERNAL_IP_ADDRESS_REF
export SUBNET_ID
envsubst < ./helm/gateway-values-template.yaml > ./helm/gateway-values.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating the Helm gateway values file'
  exit 1
fi

#
# Deploy the NGINX ingress controller and use an AWS network load balancer
#
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values=./helm/gateway-values.yaml
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
# Get the external host name
#
EXTERNAL_HOST_NAME=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "The external host name is $EXTERNAL_HOST_NAME"
