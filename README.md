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

## Phase 1: Dockerization & Cloud Registry (March 11, 2026)
- [x] Developed a RESTful API with Node.js using Environment Variables for DB connection.
- [x] Created a lightweight Docker image using `node:18-slim`.
- [x] Configured AWS CLI on Ubuntu and authenticated with IAM.
- [x] Created a Private Amazon ECR repository and successfully pushed the image.
- [x] Set up IAM User with Administrator permissions for team collaboration.

## 🏗️ Phase 2 & 3: Infrastructure & Deployment (March 12, 2026)
In this phase, we transitioned from local containerization to a fully functional, secure, and scalable cloud architecture on AWS.

### 🛡️ Security & Identity (IAM)
Principle of Least Privilege: Created a custom IAM Instance Profile (EC2-ECR-Pull-Role) for the EC2 instance.

Access Control: Attached AmazonEC2ContainerRegistryReadOnly and AmazonSSMManagedInstanceCore policies to allow the instance to pull images securely without hardcoded credentials.

### 🌐 Networking & Databases (VPC & RDS)
Database Isolation: Provisioned an Amazon RDS (MySQL) instance within Private Subnets to ensure it is not accessible from the public internet.

DB Subnet Groups: Configured a custom Subnet Group spanning multiple Availability Zones (us-east-1a, us-east-1b) for High Availability.

Security Group Chaining: Implemented an SG-to-SG inbound rule. The RDS Security Group only allows traffic on port 3306 from the specific Security Group ID of the EC2 instance, rather than a static IP.

### 💻 Compute & Orchestration (EC2 & Docker)
Instance Environment: Launched an Amazon Linux 2023 EC2 instance in a Public Subnet.

Remote Management: Utilized EC2 Instance Connect for secure terminal access.

Container Deployment:

Installed and configured Docker on the Amazon Linux environment.

Authenticated with Amazon ECR to pull the resume-api:latest image.

Deployed the container using environment variables to securely link the application with the RDS endpoint.

### 🚀 Final Result
The API is now live and successfully communicating with the RDS backend.

Endpoint: http://3.226.253.122:8080/api/resume
Status: Connection verified and data is being served as JSON.
