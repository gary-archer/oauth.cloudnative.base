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
# Create a MySQL secret for passwords
#
kubectl -n wordpress create secret generic mysql-passwords \
  --from-literal=mysql-root-password='Password1' \
  --from-literal=mysql-replication-password='Password1' \
  --from-literal=mysql-password='Password1'
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating MySQL secrets'
  exit 1
fi

#
# Create the MySQL resources
#
kubectl -n wordpress apply -f ./mysql.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the MySQL component'
  exit 1
fi

#
# Create the Wordpress resources
#
kubectl -n wordpress apply  -f ./wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress component'
  exit 1
fi
