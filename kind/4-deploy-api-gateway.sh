#!/bin/bash

######################################################
# Deploy the API gateway to get an external IP address
######################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

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
# Deploy the NGINX ingress controller
#
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --values=./resources/nginx-helm-values.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the ingress controller'
  exit 1
fi

#
# Wait for NGINX to be ready
#
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

#
# Report its external IP address
#
EXTERNAL_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "The external IP address is $EXTERNAL_IP"

#
# Get the API gateway's self-signed root CA so that you can configure trust for it, e.g. in the browser
#
kubectl -n cert-manager get secret/external-root-secret -o jsonpath="{.data['tls\.crt']}" | base64 -d > ./resources/rootca.crt
if [ $? -ne 0 ]; then
  echo '*** Unable to get the root certificate for the API gateway'
  exit 1
fi
