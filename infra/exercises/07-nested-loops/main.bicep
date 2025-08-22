targetScope = 'resourceGroup'

// !: --- Parameters ---
@description('List of environments to deploy')
param environments array = [
  'dev'
  'test'
]

@description('Azure location for the resources')
param location string = resourceGroup().location

@description('Definition of VNets and their subnets')
param virtualNetworks array = [
  {
    env: 'dev'
    name: 'vnet_dev'
    addressPrefix: '10.0.0.0/16'
    subnets: [
      { name: 'frontend', addressPrefix: '10.0.1.0/24' }
      { name: 'backend', addressPrefix: '10.0.2.0/24' }
      { name: 'database', addressPrefix: '10.0.3.0/24' }
    ]
  }
  {
    env: 'test'
    name: 'vnet_test'
    addressPrefix: '10.1.0.0/16'
    subnets: [
      { name: 'frontend', addressPrefix: '10.1.1.0/24' }
      { name: 'backend', addressPrefix: '10.1.2.0/24' }
      { name: 'database', addressPrefix: '10.1.3.0/24' }
    ]
  }
]

// !: --- Resources ---
resource vnetRes 'Microsoft.Network/virtualNetworks@2024-03-01' = [
  for vnet in virtualNetworks: if (contains(environments, vnet.env)) {
    name: vnet.name
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: [vnet.addressPrefix]
      }
      subnets: [
        for subnet in vnet.subnets: {
          name: subnet.name
          properties: {
            addressPrefix: subnet.addressPrefix
          }
        }
      ]
    }
  }
]

// !: --- Outputs ---
output deployedVirtualNetworks array = [for vnet in virtualNetworks: contains(environments, vnet.env) ? vnet.name : '']
