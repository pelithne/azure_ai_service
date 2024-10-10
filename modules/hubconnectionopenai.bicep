param parentResourceId string
param accountsName string
param aoaiResourceId string
param location string

resource workspacehub 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' existing = {
  name: parentResourceId
}

resource hub_connection_openai 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspacehub
  name: accountsName
  properties: {
    authType: 'AAD'
    category: 'AzureOpenAI'
    target: 'https://${accountsName}.openai.azure.com/'
    useWorkspaceManagedIdentity: true
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aoaiResourceId
      location: location
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
    }
  }
}
