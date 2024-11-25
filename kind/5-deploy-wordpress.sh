#!/bin/bash

#########################################################
# Deploy application level components using a shared file
#########################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

export MYSQL_PASSWORD='Password1'
export WORDPRESS_HOSTNAME='wordpress.authsamples-k8s-dev.com'

#
# First delete the namespace if it exists
#
kubectl delete namespace wordpress 2>/dev/null

#
# Create KIND specific persistent volumes
#
kubectl delete  -f ./resources/persistent-volumes.yaml 2>/dev/null
kubectl apply   -f ./resources/persistent-volumes.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered restoring persistent volumes'
  exit 1
fi

#
# Then run the main deployment
#
../shared/deploy.sh
if [ $? -ne 0 ]; then
  echo '*** Problem encountered deploying Wordpress components'
  exit 1
fi
