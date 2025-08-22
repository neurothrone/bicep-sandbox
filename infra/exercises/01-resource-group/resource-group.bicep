targetScope = 'subscription'

@description('Name of the resource group to create')
param name string = 'rg-exercise-01'

@description('Location for the resource group')
param location string = 'swedencentral'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: name
  location: location
}
