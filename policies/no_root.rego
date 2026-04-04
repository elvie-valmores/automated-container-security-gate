# The "package" groups your policies together
package user.dockerfile.root

# We define a "deny" rule. If the conditions inside are met, the scan fails.
deny[msg] {
    # 1. Look through all the commands in the Dockerfile
    command := input.stages[_].commands[_]
    
    # 2. Find the command where the developer typed "USER"
    command.Cmd == "user"
    
    # 3. Check if the value assigned to that user is "root"
    command.Value[0] == "root"
    
    # 4. If all the above is true, trigger this GRC violation message:
    msg := "GRC POLICY VIOLATION: Containers are prohibited from running as root."
}