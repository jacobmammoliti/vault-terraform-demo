# Vault Terraform Demo

## Introduction
This demo will show you how to install Vault on a Kubernetes cluster using the official Helm Chart from HashiCorp and then manage Vault's configuration through Terraform with the Vault provider.

## Standing up Kubernetes and Installing Vault
The Terraform code in the `terraform-vault-deployment` directory stands up a GKE cluster in a Google project, installs Vault through the official [Helm chart](https://github.com/hashicorp/vault-helm), and prints out the IP address of the Vault UI service.

The following snippet shows an example of how this is done.
```shell
$ cd terraform-vault-deployment

terraform-vault-deployment $ cat << EOF > main.tfvars
cluster_name = "vault-cluster"
project      = <project-id>
EOF

terraform-vault-deployment $ terraform apply -var-file=main.tfvars
data.google_client_config.default: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:
...

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_container_cluster.kubernetes_cluster: Creating...
google_container_cluster.kubernetes_cluster: Still creating... [10s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [20s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [30s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [40s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [50s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [1m0s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [1m10s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [1m20s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [1m30s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [1m40s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [1m50s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [2m0s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [2m10s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [2m20s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [2m30s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [2m40s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [2m50s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [3m0s elapsed]
google_container_cluster.kubernetes_cluster: Still creating... [3m10s elapsed]
google_container_cluster.kubernetes_cluster: Creation complete after 3m12s [id=projects/blizzard-253119/locations/us-central1-a/clusters/vault-cluster]
kubernetes_namespace.vault: Creating...
kubernetes_namespace.vault: Creation complete after 0s [id=vault]
helm_release.vault: Creating...
helm_release.vault: Still creating... [10s elapsed]
helm_release.vault: Still creating... [20s elapsed]
helm_release.vault: Still creating... [30s elapsed]
helm_release.vault: Still creating... [40s elapsed]
helm_release.vault: Creation complete after 48s [id=vault]
data.kubernetes_service.vault_svc: Refreshing state...

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

vault_address = http://<public-ip>:8200
```

## Initializing and Unsealing the Vault
When a Vault cluster is provisioned, it first needs to be initalized and unsealed. I have left this as a manual step and believe it should to prevent any sensitive data such as unseal keys/initial root token being saved in state.

Below are the steps to initialize and unseal the vault.

```shell
terraform-vault-deployment $ export VAULT_ADDR=http://<public-ip>:8200
terraform-vault-deployment $ vault operator init
Unseal Key 1: BI4moZsol5aWxJaGZY9MS/V2V7VrD3E8JpF+j9obIuqJ
Unseal Key 2: IFE8IEy85dxJSljK2996h8hl8oo/TA0ezQdMJtqVZmGc
Unseal Key 3: eZUo5j5bnTkXDVpy+FgMVIM6jCwOrI5g6aHbFEWxXC5U
Unseal Key 4: WKEaGQVgP35yl57z7esgKFosExXAyr/3AZ6YPO9MpzH8
Unseal Key 5: 8CbSC3Nw314btN8aN1nYzHWPYLrhm+hj2bB+iLYNUHz9

Initial Root Token: s.j0vuCJsL16RrsErxPjoiXKOc

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.

terraform-vault-deployment $ vault operator unseal BI4moZsol5aWxJaGZY9MS/V2V7VrD3E8JpF+j9obIuqJ
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       b7063581-df44-d14c-e783-079c59042e1f
Version            1.3.1
HA Enabled         false

terraform-vault-deployment $ vault operator unseal IFE8IEy85dxJSljK2996h8hl8oo/TA0ezQdMJtqVZmGc
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       b7063581-df44-d14c-e783-079c59042e1f
Version            1.3.1
HA Enabled         false

terraform-vault-deployment $ vault operator unseal eZUo5j5bnTkXDVpy+FgMVIM6jCwOrI5g6aHbFEWxXC5U
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.3.1
Cluster Name    vault-cluster-bcc8e10d
Cluster ID      c6ad36a7-f55b-b7b5-7f7d-eaf16dcb38e5
HA Enabled      false
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