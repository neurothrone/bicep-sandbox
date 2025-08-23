targetScope = 'resourceGroup'

// !: --- Types ---
import { environmentType } from '../types.bicep'

type storageSkuType = 'Standard_LRS' | 'Standard_GRS' | 'Standard_ZRS' | 'Premium_LRS'

type storageKindType = 'StorageV2' | 'FileStorage' | 'BlockBlobStorage'

@export()
type storageSettingsType = {
  @description('Deployment location (must be a valid Azure region)')
  location: string
  @description('Environment suffix to append to the storage account name')
  environment: environmentType
  @description('Storage account name (3-20 lowercase letters and numbers)')
  @minLength(3)
  @maxLength(20)
  storageName: string
  @description('SKU name, e.g. Standard_LRS, Standard_GRS, Standard_ZRS, Premium_LRS')
  storageSku: storageSkuType
  @description('Storage kind, e.g. StorageV2, FileStorage, BlockBlobStorage')
  storageKind: storageKindType
}

// !: --- Parameters ---
param settings storageSettingsType

@description('Tags to apply to the resource')
param tags object

// !: --- Resources ---
resource storage 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: toLower('${settings.storageName}${settings.environment}')
  location: settings.location
  sku: {
    name: settings.storageSku
  }
  kind: settings.storageKind
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
  tags: tags
}

// !: --- Outputs ---
@description('Storage account resource id')
output idOutput string = storage.id

output nameOutput string = storage.name

@description('Primary Blob Endpoint URL for the Storage Account')
output primaryBlobEndpointOutput string = storage.properties.primaryEndpoints.blob
