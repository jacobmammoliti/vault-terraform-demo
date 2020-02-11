path "developers/*"
{
  capabilities = ["list"]
}

path "developers/data/user"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}