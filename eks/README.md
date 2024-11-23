# EKS Base Deployment

Demonstrates AWS cloud deployment to set up a cluster, hard disk storage and DNS entry points.\
The main logic is the same as for KIND except that there is plumbing to grant AWS permissions.

## Deployment

Run the following script in a terminal window:

```bash
./1-create-cluster.sh
```

Next prepare AWS persistent volumes to enable AWS data storage external to the cluster.\
An Elastic Block Storage CSI driver inside the cluster is given permissions to use EC2 volumes.

```bash
./2-prepare-persistent-storage.sh
```

Next install AWS load balancer prerequisites to enable external access to the cluster.\
An AWS load balancer controller inside the cluster is given permissions to create EC2 load balancers.

```bash
./3-prepare-load-balancer.sh
```

Next grant cert-manager permissions to interact with Route 53 so that it can issue TLS certificates to the gateway.\
The DNS solver proves that we own the `wordpress.authsamples-k8s.com` domain.

```bash
./3-prepare-certificate-issuance.sh
```

Then create an API gateway inside the cluster which also triggers creation of a network load balancer.\
The load balancer uses a static IP address mapped to the Wordpress domain name in AWS Route 53.\
The load balancer uses TCP passthrough to terminate TLS at the API gateway entry point to the cluster.

```bash
./5-deploy-api-gateway.sh
```

Application level components use an ingress to receive traffic from the API gateway.\
Application level components use a persistent volume claim to integrate with external data storage.\
Access the system at `https://wordpress.authsamples-k8s.com`.

```bash
./6-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./7-delete-cluster.sh
```
