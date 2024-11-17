#!/bin/bash

#########################################################
# Deploy application level components using a shared file
#########################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

export MYSQL_PASSWORD='Password1'
export WORDPRESS_HOSTNAME='wordpress.authsamples-k8s-dev.com'

../shared/deploy.sh
if [ $? -ne 0 ]; then
  echo '*** Problem encountered deploying Wordpress components'
  exit 1
fi
