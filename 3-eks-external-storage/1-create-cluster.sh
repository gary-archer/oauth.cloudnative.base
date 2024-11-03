#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create an EKS cluster
#
eksctl delete cluster --name example
eksctl create cluster --name example -f ./cluster/cluster-configuration.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Kubernetes cluster'
  exit 1
fi

{
 “Version”: “2012-10-17”,
 “Statement”: [
 {
 “Effect”: “Allow”,
 “Action”: [
 “ec2:AttachVolume”,
 “ec2:CreateSnapshot”,
 “ec2:CreateTags”,
 “ec2:CreateVolume”,
 “ec2:DeleteSnapshot”,
 “ec2:DeleteTags”,
 “ec2:DeleteVolume”,
 “ec2:DescribeAvailabilityZones”,
 “ec2:DescribeInstances”,
 “ec2:DescribeSnapshots”,
 “ec2:DescribeTags”,
 “ec2:DescribeVolumes”,
 “ec2:DescribeVolumesModifications”,
 “ec2:DetachVolume”,
 “ec2:ModifyVolume”
 ],
 “Resource”: “*”
 }
 ]
}

#
# Install the EBS CSI driver
#
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm upgrade — install aws-ebs-csi-driver \
 — namespace kube-system \
 — set enableVolumeScheduling=true \
 — set enableVolumeResizing=true \
 — set 'podAnnotations.iam\.amazonaws\.com/role'=ROLE_ARN \
 — set 'node.podAnnotations.iam\.amazonaws\.com/role'=ROLE_ARN \
 aws-ebs-csi-driver/aws-ebs-csi-driver

#
# Apply the custom storage class to use EBS with gp3
#
kubectl apply -f cluster/custom-storageclass.yaml
