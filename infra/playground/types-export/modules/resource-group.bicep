targetScope = 'subscription'

// !: --- Types ---
@export()
type resourceSettingsType = {
  @description('Resource Group name')
  resourceGroupName: string

  @description('Location for the resource group')
  location: string
}

// !: --- Parameters ---
@description('Settings for the resource group')
param settings resourceSettingsType

@description('Tags to apply to the resource')
param tags object

// !: --- Resources ---
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: settings.resourceGroupName
  location: settings.location
  tags: tags
}

// !: --- Outputs ---
output nameOutput string = resourceGroup.name
output locationOutput string = resourceGroup.location
