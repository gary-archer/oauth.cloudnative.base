# Basic Dynamic Provisioning

A deployment that uses the rancher.io/local-path storageclass shipped with KIND.\
This provisions volumes dynamically for wordpress files and mysql data.

## Physical Storage

Data from MySQL pods is stored on nodes at locations like this:

```text
/var/local-path-provisioner/pvc-b66702d7-a3d5-4530-9577-8d256e8a1ecd_default_mysql-pv-claim
/var/local-path-provisioner/pvc-72af6d1a-8a51-4670-b0ef-e4b4839ab769_default_wp-pv-claim
```
