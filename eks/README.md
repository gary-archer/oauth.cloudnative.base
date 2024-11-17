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
The load balancer uses a static IP address that I map to the Wordpress domain name in AWS Route 53.\
The load balancer uses TLS passthrough to route all requests to the API gateway entry point to the cluster.

```bash
./4-deploy-api-gateway.sh
```

Application level components use an ingress to integrate with the external load balancer.\
Application level components use a persistent volume claim to integrate with external data storage:

```bash
./5-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./6-delete-cluster.sh
```
