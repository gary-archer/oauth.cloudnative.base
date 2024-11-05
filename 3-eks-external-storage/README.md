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

Follow the EBS notes below and then run the script to deploy Wordpress components:

```bash
./3-deploy-wordpress.sh
```

## Elastic Block Storage

If they do not yet exist, create EBS volumes in the AWS Console under EC2 with these names:

- mysql     2GB gp3
- wordpress 2GB gp3

Then navigate to `IAM / Roles` and find the role containing `NodeInstanceRole`, which will have a name of this form:

```text
eksctl-example-nodegroup-example-n-NodeInstanceRole-XyfnntNSLEH9 
```

Add a JSON inline policy to the role, called `K8S_EBS_Volume_Permissions`, that enables integration with EC2 volumes:


```json
{
 "Version": "2012-10-17",
 "Statement": [{
  "Effect": "Allow",
  "Action": [
   "ec2:CreateVolume",
   "ec2:DeleteVolume",
   "ec2:DetachVolume",
   "ec2:AttachVolume",
   "ec2:DescribeInstances",
   "ec2:CreateTags",
   "ec2:DeleteTags",
   "ec2:DescribeTags",
   "ec2:DescribeVolumes"
  ],
  "Resource": "*"
 }]
}
```
