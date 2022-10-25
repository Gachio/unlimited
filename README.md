Run terraform init with the -backend-config argument to put all the partial configurations together:

    terraform init -backend-config=backend.hcl

To provision the full configuration used by a module terraform merges the partial configuration in backend.hcl with the partial configuration in the Terraform code.