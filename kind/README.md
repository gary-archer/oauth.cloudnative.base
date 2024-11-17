# KIND External Storage

Demonstrates deployment with external storage so that cluster deletion does not lose data.\
MySQL data and Wordpress files are stored under the `/tmp/hostpath-provisioner` folder on the host computer.

## Deployment

Run the following script to create the KIND cluster:

```bash
./1-create-cluster.sh
```

Next install load balancer prerequisites to enable external access to the cluster:

```bash
./2-prepare-load-balancer.sh
```

Then create an API gateway inside the cluster which also triggers assignment of an external IP address.\
The script outputs the load balancer's external IP address which you map to `wordpress.example` in your hosts file.\
The load balancer uses TLS passthrough to route all requests to the API gateway entry point to the cluster.

```bash
./3-deploy-api-gateway.sh
```


Then run the script to deploy Wordpress components:

```bash
./4-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./5-delete-cluster.sh
```
