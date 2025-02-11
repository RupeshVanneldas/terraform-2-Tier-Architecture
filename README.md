# Two-Tier Web Application Automation with Terraform, Ansible, and GitHub Actions

## Project Overview
This project demonstrates the use of modern DevOps practices to design and implement a two-tier static web application hosting solution in AWS. It utilizes Terraform for infrastructure provisioning, Ansible for configuration management, and GitHub Actions for deployment automation. 

## Components
- **Terraform**: Provisions AWS resources including VPCs, subnets, EC2 instances, and a Load Balancer.
- **Ansible**: Configures web servers and deploys application content.
- **GitHub Actions**: Automates deployment workflows triggered by commits to the repository.

---

## Prerequisites

### Tools
- **Terraform**: Install the [Terraform CLI](https://www.terraform.io/downloads.html).
- **AWS CLI**: Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Ansible**: Installed on your local environment or AWS Cloud9.

### AWS Setup
#### 1. Create an S3 Bucket for Terraform State
```bash
aws s3 mb s3://<your-unique-bucket-name>
```

#### 2. Update Terraform Backend Configuration
Update `backend.tf` files in the `Network` and `Webserver` modules with your S3 bucket name and region:
```hcl
terraform {
  backend "s3" {
    bucket         = "<your-unique-bucket-name>"
    key            = "terraform/state"
    region         = "<your-region>"
  }
}
```

#### 3. Optional: Set Up AWS Cloud9 Environment
Install required dependencies:
```bash
sudo yum update -y
sudo yum install python3-pip -y
pip install ansible boto3 botocore
```

---

## Deployment Steps

### Using Terraform
#### Network Module
1. Navigate to the Network directory:
    ```bash
    cd Network
    ```
2. Initialize Terraform:
    ```bash
    terraform init
    ```
3. Generate and review the execution plan:
    ```bash
    terraform plan
    ```
4. Apply the Terraform configuration:
    ```bash
    terraform apply --auto-approve
    ```

#### Webserver Module
1. Navigate to the Webserver directory:
    ```bash
    cd ../Webserver
    ```
2. Initialize Terraform:
    ```bash
    terraform init -reconfigure
    ```
3. Generate and review the execution plan:
    ```bash
    terraform plan
    ```
4. Apply the Terraform configuration:
    ```bash
    terraform apply --auto-approve
    ```

### Using Ansible
1. Ensure the private key permissions are correct:
    ```bash
    chmod 400 ../Webserver/project_key
    ```
2. Run the Ansible playbook:
    ```bash
    ansible-playbook playbook_deploy.yaml -i aws_ec2.yaml --private-key ../Webserver/project_key
    ```

---

## GitHub Actions Workflow
A GitHub Actions workflow automates Terraform deployments on commits to the `main` branch.

### Workflow File
Create a `.github/workflows/workflow.yml` file with the following content:

```yaml
name: Terraform Apply on Commit

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Init and Apply for Network
        working-directory: ./Network
        run: |
          terraform init
          terraform apply -auto-approve

      - name: Terraform Init and Apply for Webserver
        working-directory: ./Webserver
        run: |
          terraform init
          terraform apply -auto-approve
```

### GitHub Secrets
Store your AWS credentials securely as GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## Verification
1. Retrieve the DNS name of the Application Load Balancer from the AWS Console.
2. Open the DNS name in your browser to verify toggling images and content served by the Nonprod EC2 instances.

---

## Cleanup
To destroy all resources:

1. Navigate to the Webserver directory and destroy resources:
    ```bash
    cd Webserver
    terraform destroy --auto-approve
    ```

2. Repeat the process in the Network directory:
    ```bash
    cd ../Network
    terraform destroy --auto-approve
    
