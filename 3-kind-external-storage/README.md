# Cluster High Availability

Demonstrates deployment with external storage so that cluster deletion does not lose data.

## Deployment

Run the following script in a terminal window:

```bash
./create-cluster.sh
```

Then run the deployment script in a second terminal window:

```bash
./deploy.sh
```

The script outputs an external IP address for Wordpress.\
Map that to the hostname `wordpress.local` in your hosts file.

## Persistent Volumes

The cluster creation now overrides KIND's default storage class to use the host computer.\
MySQL data and Wordpress files are stored under the `/tmp/hostpath-provisioner` folder:
You can recreate the whole cluster without data loss.
