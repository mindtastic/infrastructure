# Infrastructure
The infrastructure that runs the mindtastic backend

## Terraform cloud

Running Terraform in a team presents some challenges like shared-state and credential management. We therefore connected this repository to [Terraform Cloud](https://app.terraform.io/app). Sensitive data like API keys and credentials are stored there and referenced via variables in our code. Additionally we get the opportunity to manage multiple states, apply them individually, and roll back to earlier versions in case our code breaks something.

Creating a pull request in this repository will trigger a speculative planning feature of Terraform Cloud, hence a plan for the code in the pull request will be generated. This is equivalent to run `terraform plan` on your local machine.

The actual execution of the plan must be started manually in the Terraform Cloud user interface. If you do not have access, please contact the infrastructure team.