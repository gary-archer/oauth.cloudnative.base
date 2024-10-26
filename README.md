# Cloud Native Data

A basic repo to rehearse Kubernetes data setups on a development computer.\
This uses a few simple Wordpress and MySQL deployments.

## 1. Docker Local

- [A Docker Compose deployment](1-docker-basic/README.md)

## 2. Pod High Availability

Storage that surives pod deletion:

- [A KIND deployment using persistent volumes](2-kind-persistent-volume/README.md)

## 3. Cluster High Availability

Storage that surives cluster recreation:

- [A KIND deployment using external storage](3-kind-external-storage/README.md)
