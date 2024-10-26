# Cloud Native Data

A repo to rehearse Kubernetes data deployment scenarios on a development computer.\
The example uses simple Wordpress and MySQL components.

## 1. Docker Local

- [A Docker Compose deployment](1-docker-basic/README.md)

## 2. Pod High Availability

Uses the KIND default storage class to survive pod deletion:

- [A KIND deployment using persistent volumes](2-kind-persistent-volume/README.md)

## 3. Cluster High Availability

Uses KIND with a custom storage class to survive cluster recreation:

- [A KIND deployment using external storage](3-kind-external-storage/README.md)
