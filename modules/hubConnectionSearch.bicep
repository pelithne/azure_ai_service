param parentResourceId string
param accountsName string
param aiServiceResourceId string
param location string

resource workspacehub 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' existing = {
  name: parentResourceId
}


resource hub_connection_azureai_search 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspacehub
  name: accountsName
  properties: {
    authType: 'AAD'
    category: 'CognitiveSearch'
    target: 'https://${accountsName}.search.windows.net'
    useWorkspaceManagedIdentity: false
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiServiceResourceId
      location: location
      ApiVersion: '2024-05-01-preview'
      DeploymentApiVersion: '2023-11-01'
    }
  }
}
