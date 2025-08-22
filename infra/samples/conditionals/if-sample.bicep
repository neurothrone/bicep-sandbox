targetScope = 'subscription'

@description('Whether to create the primary RG.')
param createRg bool = true

@description('Names for the two possible resource groups.')
param primaryRgName string = 'rg-primary'
param fallbackRgName string = 'rg-fallback'

@description('Location to deploy into.')
param location string = deployment().location

// Expressions: use ternary
var tagValue = createRg ? 'primary' : 'fallback'

// Resources: use inverse `if` conditions
resource primaryRg 'Microsoft.Resources/resourceGroups@2025-04-01' = if (createRg) {
  name: primaryRgName
  location: location
  tags: {
    role: tagValue
  }
}

resource fallbackRg 'Microsoft.Resources/resourceGroups@2025-04-01' = if (!createRg) {
  name: fallbackRgName
  location: location
  tags: {
    role: tagValue
  }
}

// Conditional output using ternary
output rgName string = createRg ? primaryRg.name : fallbackRg.name
