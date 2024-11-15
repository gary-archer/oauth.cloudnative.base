# KIND External Storage

Demonstrates deployment with external storage so that cluster deletion does not lose data.\
MySQL data and Wordpress files are stored under the `/tmp/hostpath-provisioner` folder on the host computer.

## Deployment

Run the following script to create the KIND cluster:

```bash
./1-create-cluster.sh
```

Then deploy a development load balancer outside of the cluster:

```bash
./2-create-load-balancer.sh
```

Then create an API gateway in another terminal window:

```bash
./3-deploy-api-gateway.sh
```

The script outputs an external IP address for Wordpress that you add to your hosts file:

```text
172.18.0.5 wordpress.example
```

Then run the script to deploy Wordpress components:

```bash
./4-deploy-wordpress.sh
```

When finished testing, tear down the cluster:

```bash
./5-delete-cluster.sh
```
