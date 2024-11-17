# Cloud Native Base Setup

A repo to demonstrate Kubernetes equivalence between a development computer and the AWS cloud.\
The example deploys Wordpress exposed over HTTPS with MySQL data storage.

## Local KIND Cluster

Local computer specific technology is only used for external hard disks and DNS entry into the cluster:

- [A KIND deployment](kind/README.md)

## AWS EKS Cluster

AWS specific technology is only used for external hard disks and DNS entry into the cluster:

- [An EKS deployment](eks/README.md)
