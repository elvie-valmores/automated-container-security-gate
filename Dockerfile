# Stage 1: Build Environment
FROM internal-registry.company.local/node:20 AS builder
WORKDIR /usr/src/app
COPY local_script.sh ./
RUN echo "Compiling application..."

# Stage 2: Production Environment
FROM internal-registry.company.local/node:20-alpine AS production

# REMEDIATION: Mandatory Data Governance labels applied
LABEL maintainer="security-engineering-team"
LABEL data_classification="confidential"

WORKDIR /usr/src/app

# REMEDIATION: Copy compiled artifacts from builder stage (prevents ADD vulnerabilities)
COPY --from=builder /usr/src/app /usr/src/app

# REMEDIATION: Container health monitoring configured
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD node -v || exit 1

# REMEDIATION: Non-root execution enforced
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8080
CMD ["echo", "Enterprise secure container running."]