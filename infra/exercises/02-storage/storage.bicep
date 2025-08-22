targetScope = 'resourceGroup'

@description('Name of the Storage Account (3-24 lowercase letters/numbers).')
@minLength(3)
@maxLength(24)
param name string = 'exercise2storage'

@description('Azure region for the Storage Account.')
param location string = 'swedencentral'

resource storage 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

@description('Storage account resource id')
output storageIdOutput string = storage.id

output storageNameOutput string = storage.name

@description('Primary Blob Endpoint URL for the Storage Account')
output primaryBlobEndpointOutput string = storage.properties.primaryEndpoints.blob
