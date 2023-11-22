# A repository of Terraform code for AWS infrastructure

 

## Setup

 - clone the repository: 
	for ssh:
    `git clone git@github.com:KwesiJoe/terraforming.git`
	
	for http:
    `git clone https://github.com/KwesiJoe/terraforming.git`
 
 - Find the AWS infrastructure component you want create. The files have the directory structure below:
 ````
 .
|____README.md
|____AWS
| |____components
| | |____s3 and cdn
| | | |____main.tf
| | | |____terraform.tfvars
| | | |____variables.tf
| | | |____provider.tf
````

- modify main.tf to suit your use case and change the variables in terraform.tfvars.
- Run `terraform init` to install plugins
-  Create an execution plan with `terraform plan` 
- Apply changes using `terraform apply`