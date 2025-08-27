targetScope = 'subscription'

@description('The name of the resource group to create')
param resourceGroupName string = 'rg-composable'

@description('The Azure region into which the resources should be deployed.')
param location string = 'swedencentral'

@description('The name of the App Service app.')
param appServiceAppName string = 'app-composable-${uniqueString(resourceGroupName)}'

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string = 'F1'

@description('Indicates whetx§her a CDN should be deployed.')
param deployCdn bool = true

var appServicePlanName = 'asp-composable-${uniqueString(resourceGroupName)}'

module resourceGroupModule 'modules/resource-group.bicep' = {
  name: 'resourceGroupModule'
  params: {
    name: resourceGroupName
    location: location
  }
}

module app 'modules/app.bicep' = {
  name: 'appModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
  }
}

module cdn 'modules/cdn.bicep' = if (deployCdn) {
  name: 'cdnModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    httpsOnly: true
    originHostName: app.outputs.appServiceAppHostName
  }
}

@description('The host name to use to access the website.')
output websiteHostName string = deployCdn ? cdn.outputs.endpointHostName : app.outputs.appServiceAppHostName
