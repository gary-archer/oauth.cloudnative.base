# Cloud Native Data

A repo to rehearse Kubernetes data deployment scenarios, primarily on a development computer.\
The example uses simple Wordpress and MySQL components.

## 1. Docker Basic

A local deployment for basic sanity checking of the underlying components:

- [A Docker Compose deployment](1-docker-basic/README.md)

## 2. Local KIND Cluster

Uses KIND with a host computer storage class so that data survives cluster recreation:

- [A KIND deployment using external storage](2-kind-external-storage/README.md)

## 3. AWS EKS Cluster

Uses EKS with RAID-like Elastic Block Storage so that data survives cluster recreation:

- [An EKS deployment using external storage](3-eks-external-storage/README.md)
