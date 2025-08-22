targetScope = 'subscription'

// !: --- Parameters ---
param resourceGroupName string = 'rg-exercise-06'
param location string = 'swedencentral'
param environments array = ['dev', 'qa', 'prod']

// !: --- Modules ---
module resourceGroupModules 'modules/resource-group.bicep' = [
  for env in environments: {
    name: 'resourceGroupModule-${env}'
    params: {
      name: '${resourceGroupName}-${env}'
      location: location
    }
  }
]

module resourceGroupModules2 'modules/resource-group.bicep' = [
  for i in range(0, 4): if (i % 2 == 0) {
    name: 'resourceGroupModule2-${i}'
    params: {
      name: '${resourceGroupName}-${i + 3}'
      location: location
    }
  }
]

// !: --- Outputs ---
output resourceGroupNames array = [for i in range(0, 3): resourceGroupModules[i].outputs.nameOutput]
output resourceGroupNames2 array = [for i in range(0, 3): resourceGroupModules2[i].outputs.nameOutput]
