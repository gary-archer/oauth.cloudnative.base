# Cluster High Availability

Demonstrates deployment with external storage so that cluster deletion does not lose data.

## Deployment

Add this ent

Run the following script in a terminal window:

```bash
./1-create-cluster.sh
```

Then run the deployment script in a second terminal window:

```bash
./2-deploy-api-gateway.sh
```

The script outputs an external IP address for Wordpress that you add to your hosts file:

```text
172.18.0.5 wordpress.example
```

Then run the script to deploy Wordpress and open the system browser once ready:

```bash
./3-deploy-wordpress.sh
```

## Data

MySQL data and Wordpress files are stored under the `/tmp/hostpath-provisioner` folder on the host computer.
