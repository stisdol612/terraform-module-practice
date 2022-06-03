# --- networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.smt_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.smt_rds_sg.*.name
}

output "db_security_group" {
  value = [aws_security_group.smt_sg["rds"].id]
}

output "public_sg" {
  value = aws_security_group.smt_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.smt_public_subnet.*.id
}