param principalId string

var roleDefinitionID = '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
var roleAssignmentName= guid(principalId, roleDefinitionID, resourceGroup().id)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionID)
    principalId: principalId
  }
}
