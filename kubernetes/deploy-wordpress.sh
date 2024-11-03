#!/bin/bash

#####################################
# Deploy application level components
#####################################

cd "$(dirname "${BASH_SOURCE[0]}")"

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
kubectl -n wordpress apply -f mysql.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the MySQL component'
  exit 1
fi

#
# Create the main Wordpress resources
#
kubectl -n wordpress apply  -f wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress component'
  exit 1
fi
