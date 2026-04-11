# Enterprise DevSecOps Pipeline: Automated GRC and Container Security

## Project Overview
This project implements a highly automated, "Shift-Left" DevSecOps pipeline using GitHub Actions. It enforces strict Governance, Risk, and Compliance (GRC) standards across both Cloud Infrastructure (IaC) and Containerized Applications. The architecture prevents misconfigured resources, exposed secrets, and vulnerable software packages from reaching the production environment.

## Technical Architecture & Tools
* **Continuous Integration:** GitHub Actions
* **Security Scanning Engine:** Trivy (Aqua Security)
* **Policy-as-Code:** Open Policy Agent (Rego)
* **Infrastructure-as-Code:** Terraform (AWS Provider)
* **Containerization:** Docker (Multi-Stage Builds)

---

## Security Pipeline Workflow
The CI/CD pipeline consists of three distinct security gates, evaluated sequentially upon every code commit. If any gate fails, the pipeline terminates immediately, preventing insecure code from progressing.

![Failed Pipeline Catching Vulnerabilities](assets/pipeline-failure.png)

1. **Gate 0: Infrastructure & Secret Scanning (Terraform)**
   * Parses `.tf` files to identify hardcoded credentials.
   * Evaluates cloud architecture against CIS AWS Benchmarks.
   * *Outcome:* Blocks deployment of unencrypted block storage (EBS), public-facing security groups, and wildcard IAM policies.
2. **Gate 1: Configuration & Policy-as-Code (Docker & Rego)**
   * Evaluates the application `Dockerfile` against custom Rego policies.
   * *Outcome:* Enforces supply chain security by mandating approved internal image registries, verifying data classification metadata (`LABEL`), and ensuring non-root execution.
3. **Gate 2: Software Supply Chain & Vulnerability Management (CVEs)**
   * Scans the compiled container binary against the global CVE database.
   * *Risk Acceptance Logic:* Pipeline is configured to fail exclusively on `CRITICAL` vulnerabilities. Unpatched vulnerabilities (`ignore-unfixed: true`) are logged but bypassed to maintain engineering velocity.

![Fully Remediated and Secure Pipeline](assets/pipeline-success.png)

---

## Remediation & Policy Enforcement Examples

Below are examples of how the pipeline catches insecure developer practices and the codified remediations required to pass the security gates.

### 1. Terraform Cloud Infrastructure (IaC)
Remediating public SSH exposure (CIS AWS 5.2) and enforcing enterprise-grade EBS encryption.

```diff
- resource "aws_security_group" "app_sg" {
-   ingress {
-     cidr_blocks = ["0.0.0.0/0"] # VULNERABLE: Open to public internet
-   }
- }
- resource "aws_ebs_volume" "app_data" {
-   encrypted = false # VULNERABLE: Unencrypted data at rest
- }

+ resource "aws_security_group" "app_sg" {
+   ingress {
+     cidr_blocks = ["10.0.0.0/8"] # SECURE: Restricted to internal corporate network
+   }
+ }
+ resource "aws_ebs_volume" "app_data" {
+   encrypted  = true # SECURE: Encrypted using Customer Managed Key (CMK)
+   kms_key_id = aws_kms_key.enterprise_ebs_key.arn
+ }
```

### 2. Docker Application Container (AppSec)
Enforcing supply chain security, non-root execution, and data governance metadata.

```diff
- FROM node:latest # VULNERABLE: Unauthorized registry and non-deterministic tag
- ADD https://raw.githubusercontent.com/expressjs/package.json ./ # VULNERABLE: Remote file fetch
- USER root # VULNERABLE: Root execution

+ FROM internal-registry.company.local/node:20-alpine AS production # SECURE: Approved internal registry
+ LABEL data_classification="confidential" # SECURE: Mandatory Data Governance
+ COPY --from=builder /usr/src/app /usr/src/app # SECURE: Local artifact copy
+ USER appuser # SECURE: Least privilege execution
```

## Conclusion & Business Impact
By codifying security standards into the CI/CD pipeline, this architecture significantly reduces the Mean Time to Remediation (MTTR) for infrastructure misconfigurations. It shifts security responsibility directly to the developer environment while providing an automated, auditable trail of compliance for GRC teams.