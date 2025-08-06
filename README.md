
#  AWS Cloud Learning Notes

This repository contains my structured notes and summaries as I study AWS Cloud concepts, with the aim of sharing knowledge and helping others learn more effectively. [Course Link](https://skillbuilder.aws/learn/94T2BEN85A/aws-cloud-practitioner-essentials)

---

<details>
<summary>✅ Six Key Benefits of the AWS Cloud</summary>

1. **Trade Fixed Expense for Variable Expense**  
   Instead of investing heavily in data centers and servers before you know how they’ll be used, pay only when you consume computing resources.

2. **Benefit from Massive Economies of Scale**  
   AWS aggregates usage across millions of customers, which lowers the cost for you.

3. **Stop Guessing Capacity**  
   Scale your infrastructure up or down based on actual usage, avoiding over-provisioning or under-provisioning.

4. **Increase Speed and Agility**  
   Deploy new resources in minutes, enabling faster experimentation and innovation.

5. **Stop Spending Money to Run and Maintain Data Centers**  
   Focus on business differentiation instead of infrastructure management.

6. **Go Global in Minutes**  
   Deploy applications in multiple regions around the world with just a few clicks.

</details>

<details>
<summary>✅ AWS Regions and Availability Zones</summary>

### AWS Regions
An **AWS Region** is a physical location in the world where AWS has multiple data centers. Each region is a separate geographic area that enables customers to deploy applications close to their users, improving latency and compliance.

### Availability Zones (AZs)
An **Availability Zone** is one or more discrete data centers with redundant power, networking, and connectivity in an AWS Region. Regions typically have multiple AZs.

Using multiple AZs allows you to design highly available and fault-tolerant applications by distributing workloads across isolated infrastructures.

</details>

<details>
<summary>✅ High Availability vs Fault Tolerance</summary>

### High Availability
High availability ensures that your application remains accessible and operational **with minimal downtime**, even during failures. It is typically achieved by distributing resources across multiple Availability Zones or regions.

**Benefits:**
- Minimizes downtime
- Improves user experience
- Reduces business impact from failures

### Fault Tolerance
Fault tolerance is the ability of a system to **continue operating without interruption**, even if one or more components fail.

**Benefits:**
- Zero downtime during failures
- Maintains operations seamlessly
- Suitable for critical systems

</details>

<details>
<summary>✅ Amazon EC2 and Multitenancy</summary>

### Amazon EC2 (Elastic Compute Cloud)
Amazon EC2 provides scalable virtual servers in the cloud. You can launch and manage servers, known as **instances**, to run your applications.

- Fully customizable (OS, storage, instance type)
- Easily scalable
- Pay-as-you-go pricing

### Multitenancy in EC2
**Multitenancy** means that multiple customers share the same physical hardware, while their environments remain isolated.

**Security in Multitenancy**:
- AWS uses hypervisors to isolate virtual machines
- Data is separated and encrypted
- Tenants can't access each other’s resources

</details>

<details>
<summary>✅ EC2 Instance Types and Use Cases</summary>

AWS provides different types of EC2 instances, each optimized for specific workloads.

### 🟦 1. General Purpose
- **Instance Families**: `t4g`, `t3`, `m6g`, `m5`
- **Use Case**: Balanced compute, memory, and networking
- **Examples**: Web servers, development/test environments, small databases

### 🟥 2. Compute Optimized
- **Instance Families**: `c6g`, `c5`
- **Use Case**: High-performance compute tasks
- **Examples**: Batch processing, gaming servers, high-performance web apps

### 🟩 3. Memory Optimized
- **Instance Families**: `r6g`, `r5`, `x1`
- **Use Case**: Memory-intensive workloads
- **Examples**: In-memory databases (e.g., Redis), real-time big data analytics

### 🟨 4. Accelerated Computing
- **Instance Families**: `p4`, `inf1`, `g4`
- **Use Case**: Hardware acceleration (GPU, FPGA)
- **Examples**: Machine learning, deep learning, video processing

### 🟫 5. Storage Optimized
- **Instance Families**: `i3`, `d2`, `h1`
- **Use Case**: High-speed, high-capacity storage
- **Examples**: Data warehousing, Hadoop, NoSQL databases

</details>

<details>
<summary>✅ AWS EC2 Pricing Models</summary>

### 1. On-Demand Instances
- Pay for compute capacity by the second or hour with no long-term commitments.
- **Best for**: Short-term, unpredictable workloads.

### 2. Savings Plans
- Commit to a consistent amount of usage (e.g., $10/hour) for 1 or 3 years in exchange for lower rates.
- More flexible than reserved instances.

### 3. Reserved Instances
- Reserve capacity for 1 or 3 years with up to 75% discount compared to on-demand.
- **Best for**: Predictable workloads.

### 4. Spot Instances
- Purchase unused EC2 capacity at discounts up to 90%.
- **Best for**: Fault-tolerant and flexible applications (e.g., batch jobs, ML training).

### 5. Dedicated Hosts
- Physical servers dedicated for your use.
- **Best for**: Compliance requirements, software licenses bound to physical cores.

</details>

<details>
<summary>✅ EC2 Scaling: Up, Out, and Auto Scaling Groups</summary>

### Vertical Scaling (Scaling Up/Down)
- **Scale Up**: Increase instance size (e.g., from `t3.small` to `t3.large`)
- **Scale Down**: Decrease instance size
- **Best for**: Applications that are difficult to distribute

### Horizontal Scaling (Scaling Out/In)
- **Scale Out**: Add more instances to handle increased load
- **Scale In**: Remove instances when load decreases
- **Best for**: Stateless applications and distributed systems

### Auto Scaling Groups (ASG)
ASGs automatically manage the number of EC2 instances based on demand.

- **Minimum Capacity**: The least number of instances to always keep running
- **Desired Capacity**: The ideal number based on current usage
- **Maximum Capacity**: The upper limit of instances that can be launched

</details>

<details>
<summary>✅ Load Balancing Algorithms</summary>

Load balancing helps distribute traffic across multiple servers to improve availability and performance. AWS offers **Elastic Load Balancing (ELB)** with several algorithm strategies:

### 1. Round Robin
- Requests are distributed **evenly** across all available servers in order.
- **Best for**: Servers with similar capacity and workload.

### 2. Least Connections
- New requests go to the server with the **fewest active connections**.
- **Best for**: Long-lived or uneven session workloads.

### 3. IP Hash
- Assigns requests to servers based on the client's **IP address**.
- **Best for**: Sticky sessions (same user goes to the same server).

### 4. Least Response Time
- Sends traffic to the server with the **fastest response time** and fewest active connections.
- **Best for**: Latency-sensitive applications.

</details>

<details>
<summary>✅ Amazon SQS vs Amazon SNS</summary>

### Amazon SQS (Simple Queue Service)
- **Type**: Message Queue (Pull-based)
- **Use Case**: Decouples components in a distributed system by using a queue for storing messages.
- **How it works**: 
  - A producer sends messages to a queue.
  - Consumers poll the queue to retrieve and process messages.

**Best for**:
- Asynchronous communication between microservices
- Load leveling and task queues

---

### Amazon SNS (Simple Notification Service)
- **Type**: Pub/Sub (Push-based)
- **Use Case**: Sends notifications or messages to multiple subscribers (e.g., email, SMS, Lambda, SQS).

**How it works**:
- A publisher sends a message to a topic.
- All subscribers to that topic receive the message instantly.

**Best for**:
- Sending alerts or notifications
- Fan-out message delivery

</details>
<details>
<summary>✅ Serverless and AWS Lambda</summary>

##  What is Serverless?

Serverless computing allows you to **build and run applications without managing servers**. It abstracts the infrastructure layer, so you can focus entirely on your code.

**Benefits:**
- No server management
- Automatic scaling
- Pay-per-use pricing (you only pay for the compute time you use)
- Faster development and deployment

---

## 🧠 AWS Lambda

**AWS Lambda** is the most popular serverless compute service in AWS.

### 🔧 How it works:
- Upload your code.
- Set a trigger (e.g., HTTP request, S3 file upload, DynamoDB change).
- Lambda runs your code in response to the event.

### ✅ Key Features:
- Supports multiple languages (Python, Node.js, Java, etc.)
- Automatic scaling
- Integrated with other AWS services (S3, DynamoDB, API Gateway, etc.)
- Max execution time per invocation: 15 minutes

### 🪄 Common Use Cases:
- Building APIs with API Gateway + Lambda
- Real-time file processing from S3
- Automation (e.g., scheduled cleanup jobs)
- Event-driven microservices
</details>



