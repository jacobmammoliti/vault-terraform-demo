# Vault Terraform Demo

## Introduction
This demo will show you how to install Vault on a Kubernetes cluster using the official Helm Chart from HashiCorp and then manage Vault's configuration through Terraform with the Vault provider.

## Standing up Kubernetes and Installing Vault
The Terraform code in the `terraform-vault-deployment` directory stands up a GKE cluster in a Google project, installs Vault through the official [Helm chart](https://github.com/hashicorp/vault-helm).

Example `terraform.tfvars`:
```HCL
cluster_name       = 'vault-cluster'
project_id         = 'my-gcp-project-id'
hostname           = 'vault'
domain             = 'example.lab'
gcp_kms_project_id = 'my-kms-project-id'
gcp_kms_key_ring   = 'vault-key-ring'
gcp_kms_crypto_key = 'vault-crypto-key'
```

## Initializing and Unsealing the Vault
When a Vault cluster is provisioned, it first needs to be initalized and unsealed. I have left this as a manual step and believe it should to prevent any sensitive data such as unseal keys/initial root token being saved in state.

Below are the steps to initialize and unseal the vault.

```shell
$ gcloud container clusters get-credentials <gke-cluster-name> --zone <gke-cluster-location> --project <gcp-project-id>

$ kubectl get pods -n vault
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 0/1     Running   0          3h49m
vault-agent-injector-68c547d6d7-zsk92   1/1     Running   0          3h49m

$ kubectl exec -it vault-0 -n vault /bin/sh
/ $ vault operator init -recovery-shares=1 -recovery-threshold=1 # do not do 1 in production please
Recovery Key 1: h4lwnpw+W2d9oIMM09PPHj56r58Iw/jDL9IWQDpNFag=
Initial Root Token: s.jQ08x0bch7nYMGbTD7kmTWMH
Success! Vault is initialized
Recovery key initialized with 1 key shares and a key threshold of 1. Please
securely distribute the key shares printed above.
```

## Configure Vault with Terraform
Now that the Vault is initalized and unsealed, we can log into Vault and configure it with our Terraform code. In the `terraform-vault-configuration` directory, we use Terraform and the Vault provider to setup Vault. 

This code can be tailored to any teams needs but the idea here is that all configuration changes to Vault should live in code and stored in some SCM repository. When a change in Vault is needed, we update the Terraform code and let Terraform make the changes. This now provides some audit trail to changes in the environment and also provides the ability to easily replicate a Vault environment if needed. 

> Note that we are using the root token for login and initial setup. It is important to note that that is all it should be used for. Once an authentication method and an initial admin policy has been created, the root token should be revoked. 

The following steps are done to configure Vault with Terraform.

```shell
terraform-vault-deployment $ vault login 
Token (will be hidden): 
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.j0vuCJsL16RrsErxPjoiXKOc
token_accessor       3vjJggW0CIJhP5tF8XUit1LX
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]

terraform-vault-deployment $ cd ../terraform-vault-configuration

terraform-vault-configuration $ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:
...

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

vault_policy.admin_policy: Creating...
vault_auth_backend.example: Creating...
vault_policy.admin_policy: Creation complete after 0s [id=admins]
vault_auth_backend.example: Creation complete after 0s [id=userpass]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
 
## Vault Policies
In this demo, I've created to Vault policies for two types of users `admins` and `developers`.
The `admin` is a type of user empowered with managing Vault for the organization. Empowered with sudo, the Administrator is focused on configuring and maintaining the health of Vault cluster(s) as well as providing bespoke support to Vault users.

Admins must be able to:

    Enable and manage auth methods broadly across Vault
    Enable and manage the key/value secrets engine at secret/ path
    Create and manage ACL policies broadly across Vault
    Read system health check

The `developer` is a type of user or service that will be used by an automated tool (e.g. Terraform to provision and configure a namespace within a Vault secrets engine for a new Vault user to access and write secrets.

Developers must be able to:

    Enable and manage auth methods
    Enable and manage the key/value secrets engine at secret/ path
    Create and manage ACL policies