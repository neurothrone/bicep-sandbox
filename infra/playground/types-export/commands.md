# Commands

## Login

```shell
az login
```

## Deploy Resource Groups

```shell
# Optional: Check for syntax errors and see the generated ARM template before deployment
bicep build main.bicep
```

```shell
# Deploy the template for the dev environment  
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.dev.bicepparam \
  --confirm-with-what-if
  
# Deploy the template for the prod environment
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.prod.bicepparam \
  --confirm-with-what-if
 
# Attempt to deploy to show what would happen if the deployment fails
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.fail.bicepparam \
  --confirm-with-what-if

# Output:
# InvalidTemplate - Deployment template validation failed: 'The provided value for the template
# parameter 'settings.storageName' is not valid. Length of the value should be less than or equal
# to '24'. Please see https://aka.ms/arm-syntax-parameters for usage details.'.
```

## Links

- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files?tabs=Bicep