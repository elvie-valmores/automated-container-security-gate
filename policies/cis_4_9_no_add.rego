package dockerfile.cis4_9

# CIS 4.9: Ensure that COPY is used instead of ADD
deny[msg] {
    command := input.stages[_].commands[_]
    command.Cmd == "add"
    
    # sprintf allows us to print the exact line of bad code the developer wrote
    msg := sprintf("GRC CIS 4.9 VIOLATION: Do not use the ADD instruction as it can fetch remote URLs. Use COPY instead. Found: %v", [command.Original])
}