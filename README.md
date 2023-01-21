# Cloud Native Data

Resilient data deployment in Kubernetes.

## 1. Docker Local

A basic local deployment to ensure that the container settings are correct.

## 2. Pod High Availability

Dynamically provisioned persistent volumes, to survive pod deletion.

## 3. Node High Availability

Use of replication using the MySQL Helm chart, to survive node deletion.

## 4. Container Storage High Availability

Store the data in pods rather than nodes, and retain high availability.

## 5. Scalability

Separate read-write replicas, and use of sharding.

## Common Behavior

Each deployment has scripts for backup, restore and MySQL upgrades.
