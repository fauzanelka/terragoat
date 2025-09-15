package terraform.policy

# Example OPA policy: deny any security group rule allowing 0.0.0.0/0 on port 22

deny[msg] {
  input.resource_changes[i].type == "aws_security_group_rule"
  rc := input.resource_changes[i]
  rc.change.after.cidr_blocks[_] == "0.0.0.0/0"
  rc.change.after.from_port <= 22
  rc.change.after.to_port >= 22
  msg := sprintf("Security group rule allows SSH from 0.0.0.0/0: %v", [rc.address])
}

# Fail if any deny rules were found
violation_count := count(deny)