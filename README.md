# Cloud Native Data

Kubernetes resilient data setup on a development computer.

## 1. Docker Local

A Docker Compose deployment of Wordpress and MySQL:

A [mysql local deployment](1-docker-local)

## 2. Pod High Availability

Dynamically provisioned single node storage, to survive pod deletion.

## 3. Node High Availability

Dynamically provisioned multi-node storage, to survive node and pod deletion.

## 4. Container Storage High Availability

Avoid storing data on nodes and use clustered pods instead.

## 5. Backup and Restores

The ability to destroy the cluster without losing data.
