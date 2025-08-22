# Commands

## Login

```shell
az login
```

## Create and deploy the resources to the subscription with a bicep file

```shell
az deployment sub create \
  --name rg-exercise-03 \
  --location swedencentral \
  --template-file main.bicep \
  --parameters \ 
    resourceGroupName=rg-exercise-03 \
    location=swedencentral \
    storageName=exercise3storage \
    storageSku=Standard_LRS \
    storageKind=StorageV2 \
    appServicePlanName=exercise3-app-plan \
    appServicePlanSku=S1 \
    appServiceSiteName=exercise3-app-service \
  --confirm-with-what-if
```