# Pod High Availability

Demonstrates surviving pod restart.

## Dynamic Provisioning

A deployment that uses the `rancher.io/local-path` storageclass shipped with KIND.\
This provisions volumes dynamically for wordpress files and mysql data.

## Deployment

Run the following script in a terminal window:

```bash
../utils/create-cluster.sh
```

Then run the deployment script in a second terminal window:

```bash
./deploy.sh
```

The script outputs an external IP address for Wordpress.\
Map that to the hostname `wordpress.local` in your hosts file.

## Node Data Storage

MySQL data is stored on a worker node at a location like this:

```text
/var/local-path-provisioner/pvc-b66702d7-a3d5-4530-9577-8d256e8a1ecd_default_mysql-pv-claim
```

Wordpress files are stored on a worker node at a location like this:

```text
/var/local-path-provisioner/pvc-72af6d1a-8a51-4670-b0ef-e4b4839ab769_default_wp-pv-claim
```

I can delete a pod and it gets recreated without data loss.
