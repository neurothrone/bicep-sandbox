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
# .../main.dev.bicepparam(18,22) : Error BCP036: The property "appServicePlanSku" expected
# a value of type "'B1' | 'F1' | 'S1'" but the provided value is of type "'P1v2'". 
# [https://aka.ms/bicep/core-diagnostics#BCP036]
```

## Delete Resource Groups

```shell
# Delete the resource group and all resources in it
az group delete --name <resource-group-name> --yes --no-wait

# Example
az group delete --name rg-types-dev --yes --no-wait
```

## Links

- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files?tabs=Bicep