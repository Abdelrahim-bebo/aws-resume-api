# 🚀 Scalable Resume API on AWS

A cloud-native Node.js application designed to demonstrate AWS Architecture best practices, including Containerization, VPC Networking, and RDS integration. This project is part of my journey towards the **AWS Solutions Architect Associate (SAA)** certification.

## 🏗 Architecture Overview
- **Compute:** Amazon EC2 (Dockerized Node.js App)
- **Registry:** Amazon ECR (Private Repository)
- **Database:** Amazon RDS (PostgreSQL/MySQL)
- **Networking:** Custom VPC with Public/Private Subnets
- **Security:** IAM Roles & Security Groups (Principle of Least Privilege)

## 🛠 Tech Stack
- **Language:** Node.js (Express.js)
- **DevOps:** Docker, Git, Ubuntu
- **Cloud:** AWS (ECR, EC2, IAM, VPC)

## 📈 Project Progress Log

### Phase 1: Dockerization & Cloud Registry (March 11, 2026)
- [x] Developed a RESTful API with Node.js using Environment Variables for DB connection.
- [x] Created a lightweight Docker image using `node:18-slim`.
- [x] Configured AWS CLI on Ubuntu and authenticated with IAM.
- [x] Created a Private Amazon ECR repository and successfully pushed the image.
- [x] Set up IAM User with Administrator permissions for team collaboration.

# AWS Infrastructure Documentation: Resume API Network

## 🌐 Architecture Overview
This section outlines the foundational network infrastructure for the `aws-resume-api`. The architecture utilizes a Virtual Private Cloud (VPC) spanning two Availability Zones (`us-east-1a` and `us-east-1b`) for high availability. The network is strictly segmented into public and private tiers to isolate internal resources from direct external access.

<img width="1500" height="660" alt="image" src="https://github.com/user-attachments/assets/2319f684-1c2a-49d7-8bdc-954b12aeefac" />


## 🗄️ Subnet Topology
The network consists of 4 isolated subnets. Public subnets are designed for internet-facing resources (e.g., Load Balancers, Bastion Hosts), while private subnets are reserved for backend computing and databases.

| Subnet Name | Type | Availability Zone | IPv4 CIDR Block | IPv6 Support |
| :--- | :--- | :--- | :--- | :--- |
| `aws-resume-api-subnet-public1-us-east-1a` | Public | `us-east-1a` | `10.0.0.0/20` | None |
| `aws-resume-api-subnet-private1-us-east-1a` | Private | `us-east-1a` | `10.0.128.0/20` | None |
| `aws-resume-api-subnet-public2-us-east-1b` | Public | `us-east-1b` | `10.0.16.0/20` | None |
| `aws-resume-api-subnet-private2-us-east-1b` | Private | `us-east-1b` | `10.0.144.0/20` | None |

## 🚦 Gateways & Routing

### Internet Gateway
* **Name:** `aws-resume-api-igw`
* **Purpose:** Provides inbound and outbound internet connectivity exclusively for the public subnets.

## 🛡️ Security Groups

The following Security Groups are configured to manage inbound and outbound traffic for the EC2 instances and resources within the network.

| Security Group Name | Protocol | Port Range | Source/Destination | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`resume-api-PassAll`** | All Traffic | All | `0.0.0.0/0` | **Testing Only:** Allows all inbound and outbound traffic. *(Note: Should be removed or restricted in production)* |
| **`resume-api-PassSSH`** | TCP (SSH) | `22` | `Your IP` / `0.0.0.0/0` | Allows secure shell access to the instances for administration. |
| **`resume-api-PassHTTP`** | TCP (HTTP) | `80` | `0.0.0.0/0` | Allows unencrypted web traffic to access the API or web servers. |

> **⚠️ Security Note:** It is highly recommended to restrict the source IP for `resume-api-PassSSH` to your specific IP address rather than allowing `0.0.0.0/0`, and to use `resume-api-PassAll` strictly for temporary debugging purposes.

## 🐳 Phase 3: Containerization (Docker & ECR)
The application is containerized and pulled directly from Amazon Elastic Container Registry (ECR).

### 1. Environment Setup
Docker is installed and configured to run automatically on the EC2 instance:
```bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
```
### 2. ECR Authentication
Authenticated the Docker CLI with the AWS ECR registry:

```Bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 422015754060.dkr.ecr.us-east-1.amazonaws.com
```
### 3. Image Deployment
Pulled the latest application image from the registry:

```Bash
docker pull 422015754060.dkr.ecr.us-east-1.amazonaws.com/resume-api:latest
```
```bash
docker images
REPOSITORY                                                TAG       IMAGE ID       CREATED        SIZE
422015754060.dkr.ecr.us-east-1.amazonaws.com/resume-api   latest    7cc3bf39340d   24 hours ago   197MB
```
