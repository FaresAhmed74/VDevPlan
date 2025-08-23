output "eks_control_plane_sg_id" {
  value = aws_security_group.eks_control_plane_sg.id
}

output "eks_worker_sg_id" {
  value = aws_security_group.eks_worker_sg.id
}
