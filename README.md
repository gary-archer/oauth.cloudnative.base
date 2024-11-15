# Cloud Native Data

A repo to provide a base setup for a portable Kubernetes architecture.\
Vendor specific dependencies are minimized so that Kubernetes behaves the same locally and when deployed.\
The example exposes Wordpress with MySQL storage.

## Local KIND Cluster

Uses KIND for local Kubernetes with external data storage and load balancing:

- [A KIND base deployment](kind/README.md)

## AWS EKS Cluster

Uses EKS for AWS cloud Kubernetes with external data storage and load balancing:

- [An EKS base deployment](eks/README.md)
