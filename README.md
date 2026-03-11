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
