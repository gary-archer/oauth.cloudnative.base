# Data Setup

An initial data setup that I may automate in better ways in future.

## EBS Permissions

In AWS Console, navigate to `IAM / Roles` and find the role containing `NodeInstanceRole` in its name:

```text
eksctl-example-nodegroup-example-n-NodeInstanceRole-XyfnntNSLEH9 
```

Add an inline policy that enables integration with EC2 volumes:

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

## Direction

EBS volumes are limited to a single availability zone, which adds a lot of complexity.\
Therefore, EFS seems like a better choice:
https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
