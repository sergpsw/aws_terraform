Use the following instruction to deploy single server in own VPC on AWS cloud.

1. Download and install latest terraform binary.
2. Clone the code from repository.
3. Create own `variable.tf` file based on `variable.tf.example`. Without that file scenario is not valid.
4. Put into `variable.tf`, variables:
- `ssh_public_key` your public key ;
- `region` define AWS region to work with;
- `access_key` and `secret_key` access_key and secret_key your AWS user.
5. Another variables can be left as they are without any changes.
6. When scenario is ready, at first run `terraform init` to download terraform dependencies.
7. Run `terraform plan` to see what will be updated or added.
8. Run `terraform apply` to apply the scenario.

At the end terraform will show public IP address of server:
- `http://<public ip>` copy to the address bar of browser to open the server;
- `ssh ubuntu@<public ip>` use the command to get access the server.
