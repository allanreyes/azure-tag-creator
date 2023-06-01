param location string

resource applicationInsight 'Microsoft.Insights/components@2020-02-02' = {
  name: 'ai-tag-creator-${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output appInsightsId string = applicationInsight.id
output instrumentationKey string = applicationInsight.properties.InstrumentationKey
