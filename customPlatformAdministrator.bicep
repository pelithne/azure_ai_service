//set scope to subscrption level
targetScope = 'subscription'

// Custom Platform Administrator Role
resource customPlatformAdministrator 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, 'Custom Platform Administrator')
  properties: {
    roleName: 'Custom Platform Administrator'
    description: 'Custom role-based access control for Platform Administrators in AI Studio'
    assignableScopes: [
      subscription().id
    ]
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/*/Delete'
          'Microsoft.Authorization/*/Write'
          'Microsoft.Authorization/elevateAccess/Action'
          'Microsoft.Blueprint/blueprintAssignments/write'
          'Microsoft.Blueprint/blueprintAssignments/delete'
          'Microsoft.Compute/galleries/share/action'
          'Microsoft.Purview/consents/write'
          'Microsoft.Purview/consents/delete'
          'Microsoft.Resources/deploymentStacks/manageDenySetting/action'
        ]
        dataActions: [
          'Microsoft.CognitiveServices/accounts/OpenAI/*'
          'Microsoft.CognitiveServices/accounts/SpeechServices/*'
          'Microsoft.CognitiveServices/accounts/ContentSafety/*'
          'Microsoft.Search/searchServices/indexes/documents/*'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'
        ]
        notDataActions: []
      }
    ]
  }
}
