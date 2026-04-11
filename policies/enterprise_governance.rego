package enterprise.docker.governance

# Rule 1: Supply Chain Security - Approved Registries Only
deny[msg] {
    command := input.stages[_].commands[_]
    command.Cmd == "from"
    image := command.Value[0]
    
    not startswith(image, "cgr.dev/chainguard/")
    not startswith(image, "internal-registry.company.local/")
    
    msg := sprintf("SECURITY VIOLATION [SC-01]: Unauthorized base image registry detected: '%v'. Deployments must use approved Chainguard or internal registries.", [image])
}

# Rule 2: Data Governance - Mandatory Metadata
deny[msg] {
    labels := {key | 
        command := input.stages[_].commands[_]
        command.Cmd == "label"
        key := command.Value[0]
    }
    
    not labels["data_classification"]
    
    msg := "COMPLIANCE VIOLATION [DG-01]: Missing 'data_classification' metadata. Container must declare data tier (Public, Internal, Confidential)."
}