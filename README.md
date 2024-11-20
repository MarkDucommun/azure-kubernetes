# What to do
1. Get an Azure subscription
2. Get the Azure CLI `brew install azure-cli`
3. Login to Azure `az login`
4. Get your subscription ID `az account show --query id -o tsv`
5. Get Azure credentials `az ad sp create-for-rbac --name "github-action-sp" --role Contributor --scopes /subscriptions/<YOUR_SUBSCRIPTION_ID>`
6. Create a federated identity credential for GitHub Actions
    ```
   az ad app federated-credential create --id <APPLICATION_ID> --parameters '{
    "name": "github-actions-oidc",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<OWNER>/<REPOSITORY>:ref:refs/heads/<BRANCH>",ym
    "audiences": ["api://AzureADTokenExchange"]
    }'
   ```
7. Create an SSH key pair `ssh-keygen -t rsa -b 4096 -C "github-actions@yourdomain.com" -f github_action_key -N ""`
8. Set the following secrets in your GitHub repository:
   - `AZURE_CLIENT_ID` - From the output of the previous command
   - `AZURE_TENANT_ID` - From the output of the previous command
   - `AZURE_SUBSCRIPTION_ID` - Your subscription ID
   - `SSH_PRIVATE_KEY` - The private key from the SSH key pair
   - `SSH_PUBLIC_KEY` - The public key from the SSH key pair
9. If you want to run ansible locally, make sure to put the private SSH key at `~/.ssh/github_action_key`


```
az role assignment create \
  --assignee <SERVICE_PRINCIPAL_OBJECT_ID> \
  --role "Application Administrator" \
  --scope /subscriptions/<YOUR_SUBSCRIPTION_ID>
```

`az ad sp list --display-name github-action-sp`
