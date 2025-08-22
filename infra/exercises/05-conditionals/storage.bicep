targetScope = 'resourceGroup'

param deployStorage bool = true
param environment string = 'dev'
param location string = 'swedencentral'

var storageSku = environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = if (deployStorage) {
  name: 'exercise4${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageSku
  }
}

output storageId string = deployStorage ? storageAccount.id : ''
