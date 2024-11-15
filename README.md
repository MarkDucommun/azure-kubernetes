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
7. Set the following secrets in your GitHub repository:
   - `AZURE_CLIENT_ID` - From the output of the previous command
   - `AZURE_TENANT_ID` - From the output of the previous command
   - `AZURE_SUBSCRIPTION_ID` - Your subscription ID
8.
