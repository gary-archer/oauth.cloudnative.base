# EKS Base Deployment

Demonstrates cloud deployment to set up a cluster, a load balancer and data storage.\
The goal is to minimize vendor specific technology.

## Deployment

Run the following script in a terminal window:

```bash
./1-create-cluster.sh
```

Next deploy base load balancer infrastructure to enable layer 4 entry to the cluster.\
An AWS load balancer controller inside the cluster is given permissions to create EC2 load balancers.

```bash
./2-create-load-balancer.sh
```

Then create an API gateway that runs within Kubernetes, which creates a concrete load balancer.\
In Route 53 I map the external host name to the custom domain `wordpress.authsamples-k8s.com`:

```bash
./3-deploy-api-gateway.sh
```

Next set up a storage class, which stores data in Elastic Block Storage.\
An EBS CSI driver inside the cluster is given permissions to use EC2 volumes.

```bash
./4-deploy-storage-class.sh
```

You can then deploy application components that use ingress and data storage:

```bash
./5-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./6-delete-cluster.sh
```
