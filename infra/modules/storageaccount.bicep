param location string = resourceGroup().location

resource functionStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'stor${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    publicNetworkAccess: 'Enabled'  
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

output storageAccountId string = functionStorageAccount.id
output storageAccountName string = functionStorageAccount.name
