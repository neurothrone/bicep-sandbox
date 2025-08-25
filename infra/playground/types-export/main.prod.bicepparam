using 'main.bicep'

param environment = 'prod'

param resourceSettings = {
  resourceGroupName: 'rg-types'
  location: 'swedencentral'
}

param storageSettings = {
  location: resourceSettings.location
  storageSku: 'Standard_LRS'
  storageKind: 'StorageV2'
}

param appServiceSettings = {
  location: resourceSettings.location
  appServiceAppName: 'app-service-types'
  appServicePlanName: 'app-plan-types'
  appServicePlanSkuName: 'B1'
  appServicePlanInstanceCount: 1
  appServiceUseLinuxOs: true
  appServiceHttpsOnly: true
}

param tags = {
  environment: environment
  project: 'types-playground'
  owner: 'zane'
  deployedBy: 'bicep'
}