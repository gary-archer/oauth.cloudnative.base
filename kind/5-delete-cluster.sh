#!/bin/bash

###################################
# A script to delete a KIND cluster
###################################

cd "$(dirname "${BASH_SOURCE[0]}")"
kind delete cluster --name=example
