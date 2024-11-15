#!/bin/bash

#####################################
# Deploy application level components
#####################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Act as an administrator to create KIND specific persistent volumes
#
kubectl delete -f persistent-volumes.yaml 2>/dev/null
kubectl apply  -f persistent-volumes.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered restoring persistent volumes'
  exit 1
fi

#
# Run the shared deployment
#
../shared/deploy.sh
if [ $? -ne 0 ]; then
  echo '*** Problem encountered deploying Wordpress'
  exit 1
fi

#
# Create the KIND specific ingress
#
kubectl -n wordpress apply -f ingress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress ingress'
  exit 1
fi
