targetScope = 'subscription'

param deploymentTimestamp string = utcNow('yyyyMMddHHmmss')

param environment string = 'env'

var resourceGroupName = 'rg-something'
var resourceGroupFullName = '${resourceGroupName}-${environment}'

var storageAccountName = 'storage-${uniqueString(subscription().id, resourceGroupFullName)}'
var storageAccountFullName = '${storageAccountName}-${environment}'
var storageModuleFullName = '${storageAccountName}-${deploymentTimestamp}-${environment}'
