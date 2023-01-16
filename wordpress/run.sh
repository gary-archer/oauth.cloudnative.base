#!/bin/bash

########################################################
# A script to create a cluster, using MySQL with volumes
########################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create a KIND cluster
#
kind delete cluster --name=data 2>/dev/null
kind create cluster --name=data --config='./cluster.yaml'
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi

#
# Create a persistent volume with up to 5GB of space
#
kubectl delete -f volume.yaml 2>/dev/null
kubectl apply  -f volume.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the volume'
  exit 1
fi

#
# Create a persistent volume claim for 1GB, for MySQL data
#
kubectl delete -f mysql-pvc.yaml 2>/dev/null
kubectl apply  -f mysql-pvc.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the MySQL persistent volume claim'
  exit 1
fi

#
# Create the main MySQL resources, which mount the volume
#
kubectl delete -f mysql.yaml 2>/dev/null
kubectl apply  -f mysql.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the MySQL component'
  exit 1
fi

#
# Create a persistent volume claim for 1GB, for Wordpress file storage
#
kubectl delete -f wordpress-pvc.yaml 2>/dev/null
kubectl apply  -f wordpress-pvc.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress persistent volume claim'
  exit 1
fi

#
# Create the main Wordpress resources, which mount the volume
#
kubectl delete -f wordpress.yaml 2>/dev/null
kubectl apply  -f wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress component'
  exit 1
fi
