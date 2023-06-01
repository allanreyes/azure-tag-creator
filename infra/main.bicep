targetScope = 'subscription'

param resourceGroupName string
param location string = deployment().location
param functionAppName string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module eventGrid 'modules/eventgrid.bicep' = {
  name: 'eventGrid'
  scope: resourceGroup
  params: {
    functionAppName: functionAppName
  }
}
