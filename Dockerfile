# ✅ REMEDIATION 1: Version Pinning (No :latest tag)
FROM node:20-alpine

WORKDIR /app

# ✅ REMEDIATION 2: Use COPY instead of ADD to prevent remote URL fetching
COPY local_script.sh /app/script.sh

# ✅ REMEDIATION 3: Include a HEALTHCHECK instruction
HEALTHCHECK --interval=30s CMD node -v || exit 1

# ✅ REMEDIATION 4: Non-root user execution
USER node
CMD ["echo", "Running a fully secure, Enterprise-grade DevSecOps pipeline!"]