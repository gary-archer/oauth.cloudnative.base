#!/bin/bash

#########################################################
# Deploy application level components using a shared file
#########################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

export MYSQL_PASSWORD='Password1'
export WORDPRESS_HOSTNAME='wordpress.authsamples-k8s.com'

#
# First delete the namespace if it exists
#
kubectl delete namespace wordpress 2>/dev/null

#
# I precreated Elastic Block Storage volumes (hard disks) with known volume IDs.
# Configure the persistent volumes resources from these fixed IDs.
#
export MYSQL_VOLUME_ID='vol-082a989477e7cdf3c'
export WORDPRESS_VOLUME_ID='vol-0ed05252b400615c7'
envsubst < ./resources/persistent-volumes-template.yaml > ./resources/persistent-volumes.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating persistent volumes yaml with IDs'
  exit 1
fi

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
