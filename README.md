
# Road Safety  - by Daniel Sahar

This repository demonstrates a complete cloud-native deployment of a simple interactive **Road Safety web application** built with Python (FastAPI). It showcases containerization, Kubernetes orchestration on AWS EKS, CI/CD with GitHub Actions, infrastructure as code with Terraform, and monitoring with CloudWatch.

## Architecture Overview
- **App**: FastAPI web app with SQLite DB for hazard reporting.
- **Infra**: AWS EKS cluster, ALB load balancer, ECR registry, VPC networking.
- **CI/CD**: GitHub Actions for automated build/deploy.
- **Monitoring**: CloudWatch logs, metrics, alarms, and dashboards.
- See [`architecture.md`](architecture.md) for detailed diagrams and components.

## Features
- Interactive web UI for reporting road hazards (type, severity, location).
- RESTful API with health checks.
- Containerized deployment with Helm charts.
- Scalable EKS setup with monitoring.
- Environment-specific configurations (dev/prod).

## Prerequisites
- **AWS Account**: With permissions for EKS, ECR, CloudWatch, etc.
- **Tools**:
  - AWS CLI (`aws configure` or SSO)
  - Terraform >= 1.5
  - kubectl
  - Helm >= 3
  - Docker
  - Git (for cloning)
- **GitHub**: Repository with Actions enabled for CI/CD.

## Quick Start

### 1. Clone and Setup
```bash
git clone <repo-url>
cd greenroad
```

### 2. Infrastructure Provisioning
```bash
cd terraform
terraform init
terraform plan -var-file=dev.tfvars  # Review changes
terraform apply -var-file=dev.tfvars
```

This creates:
- VPC with public/private subnets
- EKS cluster and node group
- ALB, ECR, IAM roles
- CloudWatch monitoring (logs, metrics, alarms, dashboard)

### 3. CI/CD Deployment
- Push to `main` branch triggers GitHub Actions.
- Builds Docker image, pushes to ECR, deploys app via Helm.
- Manual: `helm upgrade --install road-safety ./helm/road-safety --set ingress.host=<your-domain>`

### 4. Access the App
- Get ALB DNS: `terraform output alb_dns_name`
- Open in browser: `http://<alb-dns>`
- Test: Submit a hazard and verify logs in CloudWatch.

## API Endpoints
- `GET /`: Home page with hazard list.
- `POST /hazards`: Submit new hazard (form data).
- `GET /health`: Health check (returns `{"status": "healthy"}`).

## Configuration
- **Terraform Variables** ([`terraform/dev.tfvars`](terraform/dev.tfvars)): Customize region, cluster name, replicas, etc.
- **Helm Values** ([`helm/road-safety/values.yaml`](helm/road-safety/values.yaml)): App-specific settings like resources and ingress.

## Monitoring & Troubleshooting
- **CloudWatch Dashboard**: `{cluster-name}-Monitoring` for metrics.
- **Logs**: `/aws/containerinsights/{cluster}/application`.
- **Alarms**: CPU/memory alerts at 80% threshold.
- **Common Issues**:
  - EKS access: Ensure kubectl context (`aws eks update-kubeconfig`).
  - Permissions: Check IAM roles and GitHub secrets.
  - Pods not starting: `kubectl logs <pod-name>`.

## Development
- **Local Run**: `cd app && python main.py` (requires Python 3.11+).
- **Docker Build**: `docker build -t road-safety ./app`.
- **Tests**: Add pytest for unit tests (integrate into CI).

## Cleanup
```bash
cd terraform
terraform destroy -var-file=dev.tfvars
```
