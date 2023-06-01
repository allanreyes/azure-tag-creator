param sysTopicName string = 'egst-subscription-scope'
param functionAppName string

resource sysTopic 'Microsoft.EventGrid/systemTopics@2022-06-15' = {
  name: sysTopicName
  location: 'global'
  properties: {
    source: '/subscriptions/${subscription().subscriptionId}'
    topicType: 'Microsoft.Resources.Subscriptions'
  }
}

resource sysSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2022-06-15' = {
  parent: sysTopic
  name: 'LogicApp-webhook-${uniqueString(resourceGroup().id)}'
  properties: {
    destination: {
      endpointType: 'AzureFunction'
      properties: {
        resourceId: resourceId('Microsoft.Web/sites/functions', functionAppName, 'CreateTags')
      }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Resources.ResourceWriteSuccess'
      ]
    }
  }
}
