# Cloud Native Data

Kubernetes resilient data setup on a development computer.

## 1. Docker Local

A basic local deployment to ensure that the container settings are correct.

## 2. Pod High Availability

Dynamically provisioned persistent volumes, to survive pod deletion.

## 3. Node High Availability

A MySQL cluster, deployed via Helm, that can survive node deletion.

## 4. Container Storage High Availability

Store the data in clustered pods rather than nodes, and retain high availability.

## 5. Scalability

Separate read-write replicas, and use of sharding.

## Common Behavior

Each deployment has scripts for backup, restore and upgrades.
