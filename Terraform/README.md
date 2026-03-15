# 🏗️ Infrastructure as Code (IaC) with Terraform

## 📖 Overview
The entire AWS infrastructure for the Resume API is provisioned and managed using **Terraform**. To ensure maintainability, scalability, and readability, the infrastructure code follows a modular approach, divided into logical files based on AWS service categories.

## 📂 Terraform File Structure & Architecture

The Terraform configuration is split into the following 6 core files:

### 1. `providers.tf` (Cloud Provider Setup)
* **Provider:** AWS.
* **Region:** `us-east-1` (N. Virginia).
* **Purpose:** Initializes the HashiCorp AWS provider (version ~> 5.0) to authenticate and communicate with the AWS API.

### 2. `vpc.tf` (Networking & Isolation)
* **VPC:** Custom Virtual Private Cloud with a `10.0.0.0/16` CIDR block and DNS hostnames enabled.
* **Public Subnets:** Two subnets (`us-east-1a`, `us-east-1b`) for internet-facing resources like the Application Load Balancer.
* **Private Subnets:** Two subnets (`us-east-1a`, `us-east-1b`) to securely isolate the backend compute (EC2) and database (RDS).
* **Routing:** Includes an Internet Gateway (IGW) and a Route Table mapped to the public subnets for external connectivity.

### 3. `security.tf` (Firewall & Access Control)
Implements the **Principle of Least Privilege** using chained Security Groups:
* **ALB-SG:** Allows public HTTP (Port 80) access from the internet (`0.0.0.0/0`).
* **EC2-ASG-SG:** Restricts incoming application traffic (Port 8080) exclusively from the `ALB-SG`. (Also includes Port 22 for SSH administration).
* **RDS-SG:** Allows MySQL traffic (Port 3306) strictly from the `EC2-ASG-SG`.
* **EFS-Server:** Allows NFS traffic (Port 2049) strictly from the `EC2-ASG-SG`.

### 4. `storage_and_db.tf` (Stateful Resources)
* **Amazon ECR (`resume-api`):** Private container registry for the Dockerized Node.js application.
* **Amazon RDS (MySQL):** A `db.t3.micro` database deployed in a private subnet group for secure data storage.
* **Amazon S3 (`resume-api-bucket-1`):** Object storage for uploaded resumes. Configured with Versioning, CORS policies, and strict Public Access Blocks.
* **Amazon EFS:** Encrypted shared file system mounted across multiple availability zones via Mount Targets.

### 5. `compute.tf` (Load Balancing & Auto Scaling)
* **Application Load Balancer (ALB):** Routes incoming HTTP traffic to the active EC2 instances across multiple AZs.
* **Target Group:** Monitors instance health on port `8080` (accepting `200` and `404` status codes).
* **Launch Template:** Defines the EC2 blueprint using a custom AMI (`ami-03500eeac27f0f059`) and `t3.micro` instance type.
* **Auto Scaling Group (ASG):** Dynamically scales compute resources (Min: 1, Max: 3) across public subnets based on a Target Tracking Policy (maintaining 70% Average CPU Utilization).

### 6. `serverless_and_cdn.tf` (Event-Driven & Edge Delivery)
* **Amazon CloudFront:** Global Content Delivery Network (CDN) with Origin Access Control (OAC) to securely serve files directly from the S3 bucket with HTTPS redirection.
* **Amazon SQS (`CV-Processing-Queue`):** Message queue configured with an access policy allowing S3 to publish messages.
* **S3 Event Notifications:** Automatically triggers an SQS message whenever a new object is created in the `resumes/` prefix.
* **Amazon SNS (`Task-Notifications`):** Pub/Sub topic used by Lambda (configured separately) to send automated email alerts upon task completion.

---

## 🚀 How to Deploy

To provision this infrastructure, ensure you have the AWS CLI configured and Terraform installed, then run:

1. **Initialize the working directory:**
   ```bash
   terraform init
2. **review the execution plan:**
```Bash
terraform plan
```
3. **Apply the configuration to AWS:**
```Bash
terraform apply
```
