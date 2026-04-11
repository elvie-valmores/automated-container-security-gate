# VIOLATION: Non-deterministic versioning and unauthorized registry
FROM node:latest

# VIOLATION: Missing mandatory data classification labels

WORKDIR /usr/src/app

# VIOLATION: Remote file execution risk via ADD instruction
ADD https://raw.githubusercontent.com/expressjs/express/master/package.json ./

RUN npm install

COPY . .

# VIOLATION: Missing HEALTHCHECK instruction

# VIOLATION: Executing application as the root user
USER root

EXPOSE 8080
CMD ["echo", "Running insecure app"]