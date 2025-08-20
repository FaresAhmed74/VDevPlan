data "aws_iam_policy_document" "assume_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json

}

resource "aws_iam_policy" "s3_rw" {
  name   = "${var.project_name}-s3-rw"
  policy = templatefile("${path.module}/policies/s3-policy.json", {
    bucket_arn = var.bucket_arn
  })
}

resource "aws_iam_policy" "secrets_get" {
  name   = "${var.project_name}-secrets-get"
  policy = file("${path.module}/policies/secrets-policy.json")
}

resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_rw.arn
}

resource "aws_iam_role_policy_attachment" "attach_secrets" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_get.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
