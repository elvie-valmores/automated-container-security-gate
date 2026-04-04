# 1. THE VULNERABILITY RISK: 
# Using an ancient version of Node.js that is packed with Critical CVEs.
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# 2. THE GRC / COMPLIANCE RISK:
# Explicitly running the container as the root user. 
# This is a massive violation of the CIS Docker Benchmarks.
USER root

# A dummy command just to keep the container alive if we were to run it
CMD ["echo", "Running a highly vulnerable container!"]