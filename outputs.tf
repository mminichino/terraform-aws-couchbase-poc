output lab-id {
    value = "lab-${random_id.labid.hex}"
}

output "db-node-public" {
  value = [
    for instance in aws_instance.couchbase_nodes:
    instance.public_ip
  ]
}

output "gen-node-public" {
  value = [
    for instance in aws_instance.generator_nodes:
    instance.public_ip
  ]
}

output "inventory_db" {
  value = [
    for instance in aws_instance.couchbase_nodes:
    instance.private_ip
  ]
}

output "inventory_gen" {
  value = [
    for instance in aws_instance.generator_nodes:
    instance.private_ip
  ]
}

output "db-node-names" {
  value = [
    for instance in aws_instance.couchbase_nodes:
    "${lookup(instance.tags, "Name")}.${var.domain_name}"
  ]
}

output "gen-node-names" {
  value = [
    for instance in aws_instance.generator_nodes:
    "${lookup(instance.tags, "Name")}.${var.domain_name}"
  ]
}

output "load-balancer-name" {
  value = aws_lb.load_balancer.dns_name
}
