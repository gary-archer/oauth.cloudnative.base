#!/bin/bash

######################################################
# Deploy the API gateway to get an external IP address
######################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
../kubernetes/deploy-api-gateway.sh