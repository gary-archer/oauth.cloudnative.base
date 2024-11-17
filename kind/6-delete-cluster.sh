#!/bin/bash

###################################
# A script to delete a KIND cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"

CLUSTER_NAME='example'
kind delete cluster --name=$CLUSTER_NAME
