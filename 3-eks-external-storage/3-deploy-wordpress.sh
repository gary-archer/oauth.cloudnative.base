#!/bin/bash

#####################################
# Deploy application level components
#####################################

cd "$(dirname "${BASH_SOURCE[0]}")"

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
# Act as an administrator to create EKS specific persistent volumes
#
#kubectl -n wordpress apply -f persistent-volumes.yaml
#if [ $? -ne 0 ]; then
#  echo '*** Problem encountered restoring persistent volumes'
#  exit 1
#fi

#
# Then deploy the application level components
#
../kubernetes/deploy-wordpress.sh