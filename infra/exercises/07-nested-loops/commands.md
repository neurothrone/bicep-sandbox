# Commands

## Login

```shell
az login
```

## Deploy Virtual Machines with Nested Loops

```shell
# Deploy both environments (default)
az deployment group create \
  --resource-group rg-exercise-07 \
  --template-file main.bicep

# Deploy only dev environment
az deployment group create \
  --resource-group rg-exercise-07 \
  --template-file main.bicep \
  --parameters environments='[\"dev\"]'
```
