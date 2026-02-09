


- Keeping Terraform as the single source of truth seems like a good practice. How do teams actually enforce this in real world environments? like, how do they prevent manual changes outside Terraform, and if a drift is detected, what are the clean or good ways to handle and resolve it?

- What I  have  done to authorize terraform is the following:
	- I have created a **terra_user** , which has permission to manipulate `s3` (the state) and `assume specific roles`. 
	- **terraform_role** also is created that will be assumed through the lifecycle of project to create the infra 

  Is this a legitimate way to do the auth,   more generally, how should we organize or  structure IAM roles and permissions? Should we create roles per module (e.g. VPC), per project, or assign permissions in a more specific way , like giving an EC2 instance only the actions it needs ?