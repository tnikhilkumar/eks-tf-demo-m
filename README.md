SimpleTimeService Deployment and EKS provisioning with Terraform

SimpleTimeService is a minimalist microservice that returns the current timestamp and the visitor's IP address in JSON format. 
This project demonstrates how to deploy the service on AWS using Terraform for infrastructure provisioning and Kubernetes (EKS) for application deployment.

The repository is organized into two main parts:
- **Terraform:** Contains all code for provisioning AWS infrastructure (VPC, EKS cluster, etc.).
- **k8s:** Contains all Kubernetes manifests (Deployment, Service) to deploy your application.

---

## Repository Structure

project-root/
├── terraform/          # Terraform configuration files for AWS infrastructure
│   ├── main.tf         # Main configuration: providers, modules, and resources
│   ├── variables.tf    # Variable definitions (region, VPC CIDR, etc.)
│   ├── outputs.tf      # Outputs (e.g., EKS cluster details)
│   └── terraform.tfvars (optional)  # Overrides for default variable values
└── k8s/                # Kubernetes manifests for deploying your application
    ├── deployment.yaml # Kubernetes Deployment for SimpleTimeService
    └── service.yaml    # Kubernetes Service (LoadBalancer) to expose the app


Prerequisites
Before starting, ensure you have the following installed and configured:

AWS CLI: Install & Configure
Terraform: Download Terraform
kubectl: Install kubectl
An AWS account with the necessary permissions
A public Docker image of your SimpleTimeService (e.g., tnikhilkumar/simple-time-service:latest)
Security Note: Do not push any AWS credentials or secrets to your public repository.

Steps to Implement and Deploy

1. Provision Infrastructure with Terraform
Navigate to the Terraform Directory:

cd terraform
Initialize Terraform: This command downloads the necessary providers and sets up your working directory.

terraform init
Review the Execution Plan: See what resources will be created.

terraform plan
Apply the Terraform Configuration: This will create your VPC (with 2 public and 2 private subnets), EKS cluster (with worker nodes in the private subnets), and other resources.

terraform apply
When prompted, type yes to confirm.

Note the Outputs: After a successful apply, Terraform will output key information such as the EKS cluster name and endpoint.

2. Configure kubectl Access
Update Your kubeconfig: Use the AWS CLI to configure kubectl for your new EKS cluster. Replace <aws_region> and <cluster_name> with your configured values:

aws eks update-kubeconfig --region <aws_region> --name <cluster_name>
Verify Cluster Connectivity: Ensure you can access the cluster by listing the nodes:

kubectl get nodes
3. Deploy Your Application Using Kubernetes Manifests
Navigate to the Kubernetes Manifests Directory:

cd ../k8s
Apply the Manifests: This command deploys your application (using the Deployment and Service YAML files).

kubectl apply -f .
4. Verify the Deployment
Check the Deployment and Pods:

kubectl get deployments
kubectl get pods
Check the Service Status: Retrieve the external IP or hostname assigned by the LoadBalancer:

kubectl get svc
Wait until an external IP or hostname appears for the simple-time-service Service.

Test the Application: Once the LoadBalancer is available, test your service:

curl http://<load-balancer-hostname>
Replace <load-balancer-hostname> with the actual value from the service output.


Review and Adjust:
The Terraform and Kubernetes configurations provided here are examples. You might need to adjust values (such as region, CIDR ranges, or instance types) based on your environment.

(Optinal)
Consider integrating CI/CD pipelines using Jenkins to automatically deploy infrastructure and application changes, further separating infrastructure code from application code.

Happy deploying!

Thank you :)
