Use the following instruction to deploy single server in own VPC on AWS cloud

1. Download and install latest terraform binary
1. Clone the code from repository
1. Create own `variable.tf` file based on `variable.tf.example`. Without that file scenario is not valid.
1. Put into `variable.tf`, variable `ssh_public_key` your public key.
1. Define AWS region to work with.
1. Another variables can be left as they are without any changes.
1. When scenario is ready, at first run `terraform init` to download terraform dependencies
1. Run `terraform plan` to see what will be updated or added.
1. Run `terraform apply` to apply the scenario

PS. The command `terraform plan` can use used in such way only when it is available globally, it was installed into system and global path is updated.

At the end terraform will show public IP address of server. Please use the command:
`ssh ubuntu@<public ip>` to get remove access to the server.

```
...
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

instance_ip_addr = 3.15.237.46
```