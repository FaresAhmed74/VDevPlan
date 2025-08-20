#  AWS Multi-Tier Web Application Infrastructure

##  Project Overview

This project deploys a production-ready, multi-tier web application infrastructure on AWS using Terraform. The architecture follows AWS best practices for high availability, security, and scalability.



##  Services & Components

### **1. Networking Layer (VPC Module)**
- **VPC**: `10.0.0.0/16` CIDR block
- **Public Subnets**: `10.0.1.0/24` (us-east-1a), `10.0.2.0/24` (us-east-1b)
- **Private Subnets**: `10.0.3.0/24` (us-east-1a), `10.0.4.0/24` (us-east-1b)
- **Internet Gateway**: Provides internet access to public subnets
- **NAT Gateway**: Enables private subnet resources to access internet
- **Route Tables**: Separate routing for public and private subnets

### **2. Compute Layer (EC2 Module)**
- **Auto Scaling Group**: 2-4 EC2 instances based on CPU utilization
- **Launch Template**: Ubuntu 22.04 LTS with custom user data
- **Load Balancer**: Application Load Balancer (ALB) with health checks
- **Security Groups**: HTTP (80), SSH (22) 
- **Instance Type**: t3.micro

### **3. Database Layer (RDS Module)**
- **Database Engine**: MySQL 8.0
- **Instance Class**: db.t3.micro
- **Storage**: 20GB GP2 storage
- **Multi-AZ**: Currently disabled (can be enabled for production) cost saving
- **Security**: Private subnet placement with security groups

### **4. Storage Layer (S3 Module)**
- **Bucket**: Product images and file storage
- **Versioning**: Enabled for data protection
- **Encryption**: Server-side encryption (AES256)
- **Access Control**: Private bucket with IAM-based access

### **5. Security & Access (IAM Module)**
- **EC2 Role**: Allows EC2 instances to access S3 and Secrets Manager
- **S3 Policy**: Read/Write access to specific bucket
- **Secrets Policy**: Read access to database credentials
- **Instance Profile**: Attached to EC2 instances

### **6. Secrets Management**
- **AWS Secrets Manager**: Stores database credentials securely
- **Auto-rotation**: Can be enabled for production
- **Access Control**: Only EC2 instances can retrieve credentials

##  Service Communication Flow

### **1. External Traffic Flow**
```
Internet → ALB → EC2 Instances
```

### **2. Database Communication**
```
EC2 Instances → RDS Security Group → RDS MySQL Database
Credentials: Retrieved from Secrets Manager via IAM role
```

### **3. Storage Communication**
```
EC2 Instances → IAM Role → S3 Bucket (Read/Write)
Policy: S3 bucket policy restricts access to EC2 instances only
```

### **4. Internal Service Communication**
```
EC2 Instances → NAT Gateway → Internet (for updates, packages)
EC2 Instances → VPC Endpoints → AWS Services (S3, Secrets Manager)
```

##  Security Features

### **Network Security**
- **VPC Isolation**: Complete network isolation
- **Security Groups**: Stateful firewall rules
- **Private Subnets**: Database and internal services
- **NAT Gateway**: Controlled internet access for private resources

### **Access Control**
- **IAM Roles**: Least privilege access principle
- **S3 Bucket Policies**: Restrictive access control
- **Secrets Manager**: Secure credential storage
- **SSH Access**: Restricted to specific IP addresses

### **Data Protection**
- **Encryption at Rest**: S3 and RDS encryption
- **Versioning**: S3 bucket versioning enabled
- **Backup**: Automated RDS backups

##  Monitoring & Observability

### **Current Monitoring**
- **ALB Health Checks**: HTTP health checks on EC2 instances
- **Auto Scaling**: CPU-based scaling (50% threshold)
- **Security Group Logging**: VPC Flow Logs capability

### **Recommended Additions**
- **CloudWatch Dashboards**: Custom metrics and alarms
- **X-Ray Tracing**: Distributed tracing for requests
- **CloudWatch Logs**: Centralized logging
- **SNS Notifications**: Alert notifications

##  Deployment Instructions

### **Prerequisites**
1. **AWS CLI** installed and configured
2. **Terraform** version >= 1.5.0
3. **SSH Key Pair** created in AWS
4. **AWS Credentials** with appropriate permissions



### **Step 1: Clone and Navigate**
```bash
git clone <your-repository>
cd AWS-Task2
```

### **Step 2: Configure Variables (Optional)**
Edit `variables.tf` to customize:
- AWS region
- VPC CIDR block
- Instance types
- Database configuration
- Project name

### **Step 3: Initialize Terraform**
```bash
terraform init
```

### **Step 4: Plan Deployment**
```bash
terraform plan
```

### **Step 5: Deploy Infrastructure**
```bash
terraform apply
```

### **Step 6: Verify Deployment**
```bash
# Get ALB DNS name
terraform output alb_dns_name

# Get RDS endpoint
terraform output rds_endpoint

# Get S3 bucket name
terraform output s3_bucket
```

### **Step 7: Test Application**
1. **Web Application**: Visit ALB DNS name in browser
2. **Database Connection**: SSH to EC2 instance and test MySQL connection
3. **S3 Access**: Verify file upload/download from EC2 instances

##  Cleanup Instructions

### **Destroy Infrastructure**
```bash
terraform destroy
```

