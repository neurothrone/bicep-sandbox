# Commands

## Login

```shell
az login
```

## Create Resource Groups

```shell
az deployment sub create \
  --name rg-exercise-06 \
  --location swedencentral \
  --template-file main.bicep \
  --parameters @main.parameters.json \
  --confirm-with-what-if
```
