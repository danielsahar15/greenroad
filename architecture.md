# Road Safety Demo Architecture

## Overview
The Road Safety Demo is a simple interactive web application built with Python (FastAPI) for reporting road hazards. It demonstrates a full cloud-native deployment on AWS, including containerization, Kubernetes orchestration, CI/CD pipelines, and monitoring.

## Architecture Diagram
```
[GitHub] --> [GitHub Actions CI/CD]
    |              |
    v              v
[Docker Build] --> [ECR Push] --> [Helm Deploy to EKS]
                              |
                              v
[User] --> [ALB] --> [EKS Pods] --> [SQLite DB]
                    |
                    v
              [CloudWatch Logs/Metrics]
```

## Components

### Application Layer
- **FastAPI App** (`app/main.py`): RESTful API with HTML templating for hazard reporting.
  - Endpoints: `/` (GET/POST for hazards), `/health` (health check).
  - Database: SQLite for simplicity (ephemeral in containers).
  - Logging: Structured logs to stdout for CloudWatch ingestion.

### Infrastructure Layer
- **AWS EKS**: Managed Kubernetes cluster for container orchestration.
  - Node Group: Auto-scaling EC2 instances.
  - Add-ons: Container Insights for metrics.
- **AWS ALB**: Application Load Balancer for ingress traffic.
  - Routes HTTP traffic to EKS pods.
  - Health checks on `/health`.
- **AWS ECR**: Elastic Container Registry for storing Docker images.
- **AWS VPC**: Isolated network with public/private subnets.

### Monitoring & Observability
- **CloudWatch Logs**: Application logs shipped via Fluent Bit.
  - Log Group: `/aws/containerinsights/{cluster}/application`.
- **CloudWatch Metrics/Alarms**: Node and pod CPU/memory monitoring.
  - Dashboard: Unified view of infrastructure and app metrics.
  - Alarms: Threshold-based alerts (e.g., >80% usage).

### CI/CD Pipeline
- **GitHub Actions**:
  - **CI**: Build Docker image on push/PR.
  - **CD**: Deploy Terraform infra and Helm app on main branch.
- **Terraform**: Infrastructure as Code for AWS resources.
- **Helm**: Kubernetes package manager for app deployment.

## Data Flow
1. User accesses app via ALB URL.
2. ALB routes to EKS pods running FastAPI.
3. App queries SQLite DB for hazards.
4. User submits new hazard; app logs and stores in DB.
5. Logs/metrics flow to CloudWatch via Fluent Bit/Container Insights.

## Deployment
- **Prerequisites**: AWS CLI, Terraform, kubectl, Helm.
- **Steps**:
  1. `terraform apply -var-file=dev.tfvars` (infra).
  2. GitHub Actions handles build/deploy automatically.
  3. Access via ALB DNS in Terraform outputs.

## Security Considerations
- IAM roles with least privilege (IRSA for Fluent Bit).
- VPC isolation; no public DB access.
- Secrets managed via GitHub Actions (avoid hardcoding).

## Scalability & Reliability
- Horizontal pod scaling via replicas.
- Rolling updates in Helm.
- Multi-AZ subnets for high availability.

## Future Enhancements
- Replace SQLite with RDS for persistence.
- Add authentication (e.g., JWT).
- Implement HPA based on metrics.
- TLS/HTTPS via ALB certificate.
