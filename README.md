# Cloud Native Data

A repo to rehearse Kubernetes data deployment scenarios on a development computer.\
The example uses simple Wordpress and MySQL components.

## 1. Docker Basic

The simplest deployment of the components, for basic sanity checking:

- [A Docker Compose deployment](1-docker-basic/README.md)

## 2. Local KIND Cluster

Uses KIND with a custom storage class so that data survives cluster recreation:

- [A KIND deployment using external storage](2-kind-external-storage/README.md)
