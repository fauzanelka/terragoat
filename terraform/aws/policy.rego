package terraform

# Default allow
default allow = true

# Deny if any resource is created without the mandatory 'cost-center' and 'owner' tags.
# This enforces financial governance and accountability.
deny[msg] {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    required_tags := {"cost-center", "owner"}
    provided_tags := {tag | resource.change.after.tags[tag]}
    missing_tags := required_tags - provided_tags
    count(missing_tags) > 0
    msg := sprintf("Resource '%s' is missing mandatory tags: %v", [resource.address, missing_tags])
}

# Deny if any EC2 instance uses an AMI that is not on the approved list.
# This enforces security hardening standards.
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_instance"
    resource.change.actions[_] == "create"
    approved_amis := { "ami-0a1b2c3d4e5f6789", "ami-0c9d8e7f6a5b4321" } # Set of approved AMIs
    not approved_amis[resource.change.after.ami]
    msg := sprintf("EC2 instance '%s' uses a non-approved AMI ('%s').", [resource.address, resource.change.after.ami])
}
