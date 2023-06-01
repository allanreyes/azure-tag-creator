param location string

resource functionAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-tag-creator'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

output functionAppPlanId string = functionAppPlan.id
