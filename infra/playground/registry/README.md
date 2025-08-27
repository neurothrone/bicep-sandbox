# Registry

## Publish a Bicep template

```shell
az bicep publish \ 
  --file ./modules/sqlDatabase.bicep \
  --target br:neurothrone.azurecr.io/bicep/modules/sql-database:v1.0.0
```
