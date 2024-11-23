# KIND External Storage

Demonstrates local deployment to set up a cluster, hard disk storage and DNS entry points.

## Deployment

Run the following script to create the KIND cluster and enable storage external to the cluster:

```bash
./1-create-cluster.sh
```

Next run a development load balancer that will use TCP passthrough to the API gateway:

```bash
./2-run-load-balancer.sh
```

Next install cert-manager to issue TLS certificates to the NGINX API gateway:

```bash
./3-prepare-certificate-issuance.sh
```

Then create an API gateway inside the cluster that uses an external IP address and a cert-manager TLS certificate.\
The script outputs the load balancer's external IP address which you map to `wordpress.authsamples-k8s-dev.com` in your hosts file.\
The load balancer uses TCP passthrough to terminate TLS at the API gateway entry point to the cluster.

```bash
./4-deploy-api-gateway.sh
```

Application level components use an ingress to receive traffic from the API gateway.\
Application level components use a persistent volume claim to integrate with external data storage.\
Access the system at `https://wordpress.authsamples-k8s-dev.com`.

```bash
./5-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./6-delete-cluster.sh
```
