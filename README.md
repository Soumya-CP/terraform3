# Artizens Azure VM

This Terraform configuration creates an Azure resource group named `artizens`
and a small Ubuntu Linux VM (`Standard_B1s`) with the required network resources.

## Deploy

1. Sign in to Azure:

   ```powershell
   az login
   ```

2. Create your local variables file:

   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```

3. Set `subscription_id` and replace `ssh_public_key` in `terraform.tfvars` with
   your public key. Find the subscription ID with
   `az account show --query id --output tsv`. If needed, generate an SSH key with
   `ssh-keygen -t ed25519`.

4. Initialize and deploy:

   ```powershell
   terraform init
   terraform plan
   terraform apply
   ```

Use `terraform output ssh_command` after deployment to obtain the SSH command.

To remove all created resources, run `terraform destroy`.
