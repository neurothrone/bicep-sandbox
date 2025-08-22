# Commands

## Login

```shell
az login
```

## Deploy a subscription-level template (create a resource group with a bicep file)

```shell
az deployment sub create \
  --name rg-exercise-01 \
  --location swedencentral \
  --template-file resource-group.bicep
```

> Note: --location is REQUIRED for subscription-scope deployments and specifies where the deployment metadata is stored.
> The resource group's own location is defined inside resource-group.bicep. You can omit --name to let Azure
> auto-generate a deployment name.

## OR create the resource group directly (skip if done above)

```shell
az group create --name rg-exercise-01 --location swedencentral
```
