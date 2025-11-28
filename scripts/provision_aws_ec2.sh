#!/usr/bin/env bash
set -euo pipefail

# Provision an Ubuntu 22.04 EC2 instance (t3.micro) with a new SSH keypair and security group.
# Requirements: AWS CLI configured with credentials and a default region.
# Usage: ./scripts/provision_aws_ec2.sh

KEY_NAME=${KEY_NAME:-dd-task-deploy-key}
SG_NAME=${SG_NAME:-dd-task-sg}
INSTANCE_NAME=${INSTANCE_NAME:-dd-task-vm}
INSTANCE_TYPE=${INSTANCE_TYPE:-t3.micro}

echo "Checking AWS credentials..."
if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "AWS CLI not configured or credentials invalid. Run 'aws configure' first." >&2
  exit 1
fi

REGION=$(aws configure get region || echo us-east-1)
echo "Using AWS region: $REGION"

# get caller IP to restrict SSH (falls back to 0.0.0.0/0 if it fails)
MY_IP=$(curl -s https://checkip.amazonaws.com || true)
if [[ -z "$MY_IP" ]]; then
  echo "Could not detect your public IP; SSH will be allowed from everywhere."
  SSH_CIDR=0.0.0.0/0
else
  SSH_CIDR="$MY_IP/32"
  echo "Your public IP detected: $MY_IP"
fi

echo "Creating key pair '$KEY_NAME' and saving to ~/.ssh/${KEY_NAME}.pem"
aws ec2 delete-key-pair --key-name "$KEY_NAME" >/dev/null 2>&1 || true
aws ec2 create-key-pair --key-name "$KEY_NAME" --query 'KeyMaterial' --output text > ~/.ssh/${KEY_NAME}.pem
chmod 600 ~/.ssh/${KEY_NAME}.pem

echo "Creating security group '$SG_NAME'"
SG_ID=$(aws ec2 create-security-group --group-name "$SG_NAME" --description "Security group for dd task" --query 'GroupId' --output text)
echo "Created SG: $SG_ID"

echo "Authorizing SSH from $SSH_CIDR and HTTP from 0.0.0.0/0"
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr $SSH_CIDR || true
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 || true

echo "Finding latest Ubuntu 22.04 (Jammy) AMI id for region $REGION"
AMI_ID=$(aws ec2 describe-images --owners 099720109477 --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" "Name=state,Values=available" --query 'Images[*].[ImageId,CreationDate]' --output json | jq -r 'sort_by(.[1])[-1][0]')
if [[ -z "$AMI_ID" || "$AMI_ID" == "null" ]]; then
  echo "Could not find Ubuntu AMI automatically. Please set AMI manually." >&2
  exit 1
fi
echo "Using AMI: $AMI_ID"

echo "Launching EC2 instance ($INSTANCE_TYPE)"
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" --query 'Instances[0].InstanceId' --output text)
echo "Instance created: $INSTANCE_ID"

echo "Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Instance public IP: $PUBLIC_IP"

echo
echo "Connection command (use the private key created at ~/.ssh/${KEY_NAME}.pem):"
echo "ssh -i ~/.ssh/${KEY_NAME}.pem ubuntu@${PUBLIC_IP}"

echo
echo "NOTE: Keep the private key secure. If you want me to deploy from here, provide the contents of ~/.ssh/${KEY_NAME}.pem as SSH_PRIVATE_KEY in a single fenced block."
