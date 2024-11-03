#!/bin/bash

######################################################
# Deploy the API gateway to get an external IP address
######################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
../kubernetes/deploy-api-gateway.sh

EXTERNAL_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "The external host name is $EXTERNAL_IP"
