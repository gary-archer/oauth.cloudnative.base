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
MySQL data and Wordpress files are stored at a location like this under a `/tmp/hostpath-provisioner` folder:

```text
pvc-d0b4776f-82d1-4ef9-9742-f2dea392607b
pvc-97595e67-9037-47c3-b85e-a63c81db8134
```

On the first deployment I backed up the persistent volumes.\
This means you can recreate the whole cluster without data loss.
