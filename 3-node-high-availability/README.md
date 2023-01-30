# Node High Availability

## Dynamic Provisioning

A deployment that uses the rancher.io/local-path storageclass shipped with KIND.\
This provisions volumes dynamically for wordpress files and mysql data.

## MySQL Storage

Data from MySQL pods is stored on multiple nodes at locations like this:

```text
/var/local-path-provisioner/pvc-683a9be7-fb97-4729-b6a0-99d90be9ffa7_default_data-mysql-primary-0
/var/local-path-provisioner/pvc-fafe11b5-f339-4bca-96f8-af4bbc19db7e_default_data-mysql-secondary-0
```

## Wordpress File Storage

Wordpress files are stored on the worker node at a location like this:

```text
/var/local-path-provisioner/pvc-72af6d1a-8a51-4670-b0ef-e4b4839ab769_default_wp-pv-claim
```

I need to implement a file replication solution to complete the setup.