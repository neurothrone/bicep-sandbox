# Commands

## Login

```shell
az login
```

## Create the Resource Groups

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
```

## Links

- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files?tabs=Bicep