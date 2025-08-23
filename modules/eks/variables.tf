variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for EKS control plane"
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for worker nodes"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS"
}

variable "node_instance_type" {
  type = string
  #default     = "t3.small"
  description = "EC2 instance type for worker nodes"
}


