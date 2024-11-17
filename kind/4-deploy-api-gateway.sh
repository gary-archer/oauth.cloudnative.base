#!/bin/bash

######################################################
# Deploy the API gateway to get an external IP address
######################################################

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
# Wait for certmanager pods to come up and allow some additional tolerance to avoid subsequent errors
#
echo 'Waiting for cert-manager pods to come up ...'
kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
sleep 10

#
# Create a cluster issuer for the API gateway's host names, so that ingress resources can be created in any namespace
#
kubectl -n cert-manager apply -f ./resources/cluster-issuer.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cluster issuer for external SSL certificate for the API gateway'
  exit 1
fi

#
# Deploy the NGINX ingress controller
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
# Get the API gateway's self-signed root CA so that we can configure trust for it, e.g. in the browser
#
kubectl -n cert-manager get secret/external-root-secret -o jsonpath="{.data['tls\.crt']}" | base64 -d > ./resources/rootca.crt
if [ $? -ne 0 ]; then
  echo '*** Unable to get the root certificate for the API gateway'
  exit 1
fi
