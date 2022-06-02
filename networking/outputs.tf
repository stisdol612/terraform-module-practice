# --- networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.smt_vpc.id
}