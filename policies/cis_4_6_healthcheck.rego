package dockerfile.cis4_6

# CIS 4.6: Ensure that HEALTHCHECK instructions have been added
deny[msg] {
    # Count how many times "healthcheck" appears in the Dockerfile
    count([c | c := input.stages[_].commands[_]; c.Cmd == "healthcheck"]) == 0
    msg := "GRC CIS 4.6 VIOLATION: Container is missing a HEALTHCHECK instruction. This is required to monitor container health."
}