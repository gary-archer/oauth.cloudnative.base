#!/bin/bash

############################################################
# Install cert-manager to issue API gateway TLS certificates
############################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Recreate the cert-manager namespace if required
#
kubectl delete namespace cert-manager 2>/dev/null

#
# Install cert-manager resources
#
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager -n cert-manager --values=certmanager-helm-values.yaml --create-namespace
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
# Create a cluster issuer for the API gateway's host names, so that ingress resources can be created in any namespace
#
kubectl apply -f ./resources/cluster-issuer.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the cluster issuer for the gateway SSL certificate'
  exit 1
fi
