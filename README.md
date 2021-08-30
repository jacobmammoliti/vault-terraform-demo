# Vault Terraform Demo

## Introduction
This demo will show you how to install Vault on a Kubernetes cluster using the official Helm Chart from HashiCorp and then manage Vault's configuration through Terraform with the Vault provider.

## Standing up Kubernetes and Installing Vault
The Terraform code in the `terraform-vault-deployment` directory stands up a GKE cluster and installs Vault through the official [Helm chart](https://github.com/hashicorp/vault-helm).

> The Service Account the Kubernetes nodes must have the `cloudkms.cryptoKeyVersions.useToDecrypt` and `cloudkms.cryptoKeyVersions.useToEncrypt` permissions if using a KMS for autounseal. The `Cloud KMS CryptoKey Encrypter/Decrypter` role can be attached. 

Example `terraform.tfvars`:
```HCL
project            = "jacobmammoliti"
vault_tls_disable  = false
vault_service_type = "LoadBalancer"
```

## Initializing and Unsealing Vault
When a Vault cluster is provisioned, it first needs to be initalized and unsealed. Proceed with the following steps:

If a KMS is not leveraged, you can configure Vault to use the Shamir method to produce unseal keys:

```bash
# initalize Vault with one key share and one key threshold
$ kubectl exec -it vault-0 -n vault -- vault operator init -key-shares=1 -key-threshold=1
Unseal Key 1: PgfBDMjWLqc+FVVY6+mXFT9kPOy/RUu9WEYS742jktw=

Initial Root Token: s.UvA9TZl4BC3VSjz2hn9PJJUG

Vault initialized with 1 key shares and a key threshold of 1...

# unseal each instance of Vault
$ for i in 0 1 2; do
  kubectl exec -it vault-0 -n vault -- vault operator unseal PgfBDMjWLqc+FVVY6+mXFT9kPOy/RUu9WEYS742jktw=
done

# verify all pods are running
$ kubectl get pods -n vault
NAME                                   READY   STATUS    RESTARTS   AGE
vault-0                                1/1     Running   0          2m51s
vault-1                                1/1     Running   0          2m51s
vault-2                                1/1     Running   0          2m51s
vault-agent-injector-98dc5c764-77gk9   1/1     Running   0          2m51s
```

If a KMS is leveraged, the above command looks very similar, however, you provide a recovery key share instead of unseal key.

> Note: Recovery keys cannot decrypt the master key and therefore are not able to unseal Vault.

Below are the steps to initialize and unseal the vault.

```bash
# initalize Vault with one key share and one key threshold
$ kubectl exec -it vault-0 -n vault -- vault operator init -recovery-shares=1 -recovery-threshold=1
Recovery Key 1: h4lwnpw+W2d9oIMM09PPHj56r58Iw/jDL9IWQDpNFag=

Initial Root Token: s.UvA9TZl4BC3VSjz2hn9PJJUG

...

# verify all pods are running
$ kubectl get pods -n vault
NAME                                   READY   STATUS    RESTARTS   AGE
vault-0                                1/1     Running   0          2m51s
vault-1                                1/1     Running   0          2m51s
vault-2                                1/1     Running   0          2m51s
vault-agent-injector-98dc5c764-77gk9   1/1     Running   0          2m51s
```