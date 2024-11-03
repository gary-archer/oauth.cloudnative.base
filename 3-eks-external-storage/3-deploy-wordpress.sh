#!/bin/bash

#####################################
# Deploy application level components
#####################################

cd "$(dirname "${BASH_SOURCE[0]}")"
export WORDPRESS_HOST_NAME='wordpress.authsamples-k8s.com'

#
# Create the Wordpress namespace in which to deploy application level resources
#
kubectl delete namespace wordpress 2>/dev/null
kubectl create namespace wordpress
if [ $? -ne 0 ]; then
  echo '*** Problem encountered restoring persistent volumes'
  exit 1
fi

#
# Act as an administrator to create KIND specific persistent volumes
#
kubectl delete -f persistent-volumes.yaml 
kubectl apply  -f persistent-volumes.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered restoring persistent volumes'
  exit 1
fi

#
# Then deploy the application level components
#
../kubernetes/deploy-wordpress.sh
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating wordpress resources'
  exit 1
fi

#
# Create the final ingress using the hostname
#
envsubst < ../kubernetes/ingress-template.yaml > ../kubernetes/ingress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating the ingress'
  exit 1
fi
kubectl -n wordpress apply -f ../kubernetes/ingress.yaml
