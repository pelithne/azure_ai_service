param parentResourceId string
param accountsName string
param aiServiceResourceId string
param location string

resource workspacehub 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' existing = {
  name: parentResourceId
}

resource hub_connection_csvc 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspacehub
  name: accountsName
  properties: {
    authType: 'AAD'
    category: 'AIServices'
    target: 'https://${accountsName}.cognitiveservices.azure.com/'
    useWorkspaceManagedIdentity: true
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiServiceResourceId
      location: location
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
    }
  }
}

output id string = hub_connection_csvc.id
