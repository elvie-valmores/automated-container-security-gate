# 1. REMEDIATION: Using a modern, patched version of Node.js
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# 2. REMEDIATION: Enforcing Least Privilege
# We switch away from root to the limited 'node' user built into this image
USER node

# A dummy command to keep it running
CMD ["echo", "Running a secure, compliant container!"]