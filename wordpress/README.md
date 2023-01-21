# Basic Dynamic Provisioning

This uses the rancher.io/local-path storageclass shipped with KIND.\
It provisions volumes dynamically.

## Physcial Storage

Data is stored on nodes at locations like this:

```text
/var/local-path-provisioner/pvc-b66702d7-a3d5-4530-9577-8d256e8a1ecd_default_mysql-pv-claim
/var/local-path-provisioner/pvc-72af6d1a-8a51-4670-b0ef-e4b4839ab769_default_wp-pv-claim
```
