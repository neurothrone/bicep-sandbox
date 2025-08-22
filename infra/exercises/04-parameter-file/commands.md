# Commands

## Login

```shell
az login
```

## Create and deploy the resources to the subscription with a bicep and parameters file

```shell
az deployment sub create \
  --name rg-exercise-04 \
  --location swedencentral \
  --template-file main.bicep \
  --parameters @main.parameters.json \
  --confirm-with-what-if
```