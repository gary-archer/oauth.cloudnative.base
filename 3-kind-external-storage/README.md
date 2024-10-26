# Cluster High Availability

Demonstrates deployment with external storage so that cluster deletion does not lose data.\
This deployment uses a MySQL Helm chart with both primary and secondary services.

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

## Volumes on the Host Computer

The cluster creation now overrides KIND's default storage class to use the host computer.\
MySQL data and Wordpress files are stored at a location like this under a `/tmp/hostpath-provisioner` folder:

```text
pvc-debe0406-b191-41e7-b350-82156fb54855
pvc-f0fe2009-a218-44ad-b46e-2ebbd12d1316
```

You can recreate the whole cluster without data loss.
