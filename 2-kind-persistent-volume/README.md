# Pod High Availability

Demonstrates deployment with persistent volumes so that pod deletion does not lose data.

## Dynamic Provisioning

A deployment that deploys a single MySql pod within a stateful set.\
It uses the default `rancher.io/local-path` storageclass shipped with KIND.\
The volumes store both mysql data and wordpress files.

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

## Volumes on Kubernetes Nodes

MySQL data is stored on a worker node at a location like this:

```text
/var/local-path-provisioner/pvc-b66702d7-a3d5-4530-9577-8d256e8a1ecd_default_mysql-pv-claim
```

Wordpress files are stored on a worker node at a location like this:

```text
/var/local-path-provisioner/pvc-72af6d1a-8a51-4670-b0ef-e4b4839ab769_default_wp-pv-claim
```

You can delete a pod and it gets recreated without data loss.
