# Amazon EKS with Karpenter – Terraform

## Overview
This repository provisions a private Amazon EKS cluster using Terraform and Karpenter for dynamic node provisioning.

## Features
- Private-only EKS cluster
- Karpenter-based autoscaling
- Multi-environment support (dev, pre-prod, prod)
- Existing VPC & subnet discovery using tags
- Secure IAM with IRSA
- Office IP security group attached to nodes

## Prerequisites
- Terraform >= 1.5
- AWS CLI configured
- kubectl, helm installed
- Existing VPC with tagged private subnets
- Existing Security Group: `OfficeIPs`
- Existing SSH key pair

## Environment Setup
```bash
cd environments/dev
terraform init
terraform plan
terraform apply

