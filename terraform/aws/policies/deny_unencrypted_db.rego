# OPA policy snippet: Require storage encryption for RDS databases
package aws.policies

deny[msg] {
  input.resource.type == "aws_db_instance"
  input.resource.config.storage_encrypted == false
  msg := sprintf("Database instance '%s' must have storage_encrypted=true", [input.resource.name])
}
