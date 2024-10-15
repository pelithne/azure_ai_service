param parentResourceId string
param accountsName string
param aiServiceResourceId string
param aiSearchResourceId string
param aiServiceName string
param aiSearchName string
param location string

resource workspacehub 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' existing = {
  name: parentResourceId
}

resource hub_connection_azureai_search 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspacehub
  name: aiSearchName
  properties: {
    authType: 'AAD'
    category: 'CognitiveSearch'
    target: 'https://${aiSearchName}.search.windows.net'
    useWorkspaceManagedIdentity: false
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiSearchResourceId
      location: location
      ApiVersion: '2024-05-01-preview'
      DeploymentApiVersion: '2023-11-01'
    }
  }
}

resource hub_connection_csvc 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspacehub
  name: aiServiceName
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
