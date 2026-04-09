package dockerfile.versioning

# Enterprise Architecture Rule: Never use the ':latest' tag for base images.
deny[msg] {
    command := input.stages[_].commands[_]
    command.Cmd == "from"
    endswith(command.Value[0], ":latest")
    msg := "ENTERPRISE POLICY VIOLATION: Base image cannot use the ':latest' tag. You must pin a specific, deterministic version."
}