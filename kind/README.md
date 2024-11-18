# KIND External Storage

Demonstrates local deployment to set up a cluster, hard disk storage and DNS entry points.

## Deployment

Run the following script to create the KIND cluster:

```bash
./1-create-cluster.sh
```

Next prepare persistent volumes to enable local data storage external to the cluster:

```bash
./2-prepare-persistent-storage.sh
```

Next install load balancer prerequisites to enable external access to the cluster:

```bash
./3-prepare-load-balancer.sh
```

Then create an API gateway inside the cluster which also triggers assignment of an external IP address.\
The script outputs the load balancer's external IP address which you map to `wordpress.authsamples-k8s-dev.com` in your hosts file.\
The load balancer uses TCP passthrough to route all requests to the API gateway entry point to the cluster.

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
