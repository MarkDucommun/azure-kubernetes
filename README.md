# What to do
1. Get an Azure subscription
2. Get the Azure CLI `brew install azure-cli`
3. Login to Azure `az login`
4. Get your subscription ID `az account show --query id -o tsv`
5. Get Azure credentials `az ad sp create-for-rbac --name "github-action-sp" --role Contributor --scopes /subscriptions/<YOUR_SUBSCRIPTION_ID> --sdk-auth`
6. Copy the output of the previous command and create a secret in your GitHub repository called `AZURE_CREDENTIALS`
7. 
