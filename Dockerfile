# 🚨 VIOLATION: Using the non-deterministic :latest tag
FROM node:latest

WORKDIR /app

# 🚨 VIOLATION: Using ADD instead of COPY
ADD http://example.com/some_script.sh /app/script.sh

# 🚨 VIOLATION: Missing a HEALTHCHECK instruction entirely

USER node
CMD ["echo", "Running the application"]