param location string

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'stor${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

resource function 'Microsoft.Web/sites@2022-09-01' = {
  name: 'fn-create-tags-${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'functionapp'
  properties: { 
    serverFarmId: appserviceplan.id
  }
}

resource appserviceplan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'asp-rgtagcreator'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'functionapp'
}




output functionAppId string = function.id
