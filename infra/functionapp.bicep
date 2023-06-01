targetScope = 'subscription'

param resourceGroupName string
param location string = deployment().location

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module storage 'modules/storageaccount.bicep' = {
  name: 'storage'
  scope: resourceGroup
  params: {
    location: location
  }
}

module appserviceplan 'modules/appserviceplan.bicep' = {
  name: 'appserviceplan'
  scope: resourceGroup
  params: {
    location: location
  }
}

module appinsights 'modules/appinsights.bicep' = {
  name: 'appinsights'
  scope: resourceGroup
  params: {
    location: location
  }
}

module functionapp 'modules/functionapp.bicep' = {
  name: 'functionapp'
  scope: resourceGroup
  params: {
    location: location
    storageAccountName: storage.outputs.storageAccountName
    applicationInsightInstrumentationKey: appinsights.outputs.instrumentationKey
    functionAppPlanId: appserviceplan.outputs.functionAppPlanId
  }
}

module roleassignment 'modules/roleassignment.bicep' = {
  name: 'roleassignment'
  scope: resourceGroup
  params: {
    principalId: functionapp.outputs.principalId
  }
}

output functionAppName string = functionapp.outputs.functionAppName
