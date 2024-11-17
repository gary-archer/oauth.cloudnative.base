#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#########################################
# Create KIND specific persistent volumes
#########################################

kubectl apply  -f ./resources/persistent-volumes.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered restoring persistent volumes'
  exit 1
fi
