# Commands

## Login

```shell
az login
```

## Deploy the storage account with a bicep file to the resource group

> OBS! This assumes that you have already created the resource group.

```shell
az deployment group create \
  --resource-group rg-exercise-02 \
  --template-file storage.bicep \
  --parameters name=exercise2storage location=swedencentral
```