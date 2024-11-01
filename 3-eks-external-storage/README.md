# EKS External Storage

Demonstrates deployment with external storage so that cluster deletion does not lose data.

## Deployment

Run the following script in a terminal window:

```bash
./1-create-cluster.sh
```

Then run the deployment script in a second terminal window.\
I use Route 53 to map the IP address to `http://wordpress.authsamples-k8s.com`:

```bash
./2-deploy-api-gateway.sh
```

I then run the script to deploy Wordpress and open the system browser once ready:

```bash
./3-deploy-wordpress.sh
```

## Data

TOOD
