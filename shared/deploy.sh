#!/bin/bash

#######################################################################################
# Once base infrastructure is in place, deployment logic is the same in any environment
#######################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Check prerequisites
#
if [ "$MYSQL_PASSWORD" == '' ]; then
  echo '*** You must set the MYSQL_PASSWORD environment variable before calling this script'
  exit 1
fi
if [ "$WORDPRESS_HOSTNAME" == '' ]; then
  echo '*** You must set the WORDPRESS_HOSTNAME environment variable before calling this script'
  exit 1
fi

#
# Ensure that persistent volumes are in a valid state to bind claims to
# If not then re-run the prepare-persistent-storage script to fix it
#
MYSQL_STATUS="$(kubectl get pv pv-mysql-data -o 'jsonpath={..status.phase}')"
if [ "$MYSQL_STATUS" != 'Available' ] && [ "$MYSQL_STATUS" != 'Bound' ]; then
  echo '*** MySQL persistent volume is not available'
  exit 1
fi
WORDPRESS_STATUS="$(kubectl get pv pv-wordpress-data -o 'jsonpath={..status.phase}')"
if [ "$WORDPRESS_STATUS" != 'Available' ] && [ "$WORDPRESS_STATUS" != 'Bound' ]; then
  echo '*** Wordpress persistent volume is not available'
  exit 1
fi

#
# Create the final Wordpress yaml file from the template file
#
envsubst < ./wordpress-template.yaml > ./wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered updating the final Wordpress yaml file'
  exit 1
fi

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
# Ensure that persistent volumes are in the expected state be released to avoid creating new ones when we redeploy
#
MYSQL_STATUS="$(kubectl get pv pv-mysql-data -o 'jsonpath={..status.phase}')"
if [ "$MYSQL_STATUS" != 'Available' ] && [ "$MYSQL_STATUS" != 'Bound' ]; then
  echo '*** MySQL persistent volume is not available'
  sleep 1;
fi
WORDPRESS_STATUS="$(kubectl get pv pv-wordpress-data -o 'jsonpath={..status.phase}')"
if [ "$WORDPRESS_STATUS" != 'Available' ] && [ "$WORDPRESS_STATUS" != 'Bound' ]; then
  echo '*** Wordpress persistent volume is not available'
  sleep 1;
fi

#
# Create a MySQL secret for passwords
#
kubectl -n wordpress create secret generic mysql-passwords \
  --from-literal=mysql-root-password="$MYSQL_PASSWORD" \
  --from-literal=mysql-replication-password="$MYSQL_PASSWORD" \
  --from-literal=mysql-password="$MYSQL_PASSWORD"
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
kubectl -n wordpress apply -f ./wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress component'
  exit 1
fi
