# EKS Base Deployment

Demonstrates cloud deployment to set up a cluster, a load balancer and data storage.\
The goal is to minimize vendor specific technology.

## Deployment

Run the following script in a terminal window:

```bash
./1-create-cluster.sh
```

Next prepare persistent volumes to enable AWS data storage external to the cluster.\
An Elastic Block Storage CSI driver inside the cluster is given permissions to use EC2 volumes.

```bash
./2-prepare-persistent-storage.sh
```


Next install load balancer prerequisites to enable external access to the cluster.\
An AWS load balancer controller inside the cluster is given permissions to create EC2 load balancers.

```bash
./3-prepare-load-balancer.sh
```

Then create an API gateway inside the cluster which also triggers creation of a network load balancer.\
 to receive external traffic using TLS passthrough from a network load balancer.\
In Route 53 I map the network load balancer's external host name to the custom domain `wordpress.authsamples-k8s.com`:

```bash
./4-deploy-api-gateway.sh
```

You can then deploy application components that use ingress and data storage:

```bash
./5-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./6-delete-cluster.sh
```
