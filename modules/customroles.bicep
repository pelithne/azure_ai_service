targetScope = 'subscription'


// Custom Project Member/Owner Role
resource customProjectMemberOwner 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, 'Custom Project Member/Owner')
  properties: {
    roleName: 'Custom Project Member/Owner'
    description: 'Custom role-based access control for Project Members and Project Owners in AI Studio'
    assignableScopes: [
      subscription().id
    ]
    permissions: [
      {
        actions: [
          '*/read'
          'Microsoft.Insights/AutoscaleSettings/write'
          'Microsoft.MachineLearningServices/workspaces/*/action'
          'Microsoft.MachineLearningServices/workspaces/*/delete'
          'Microsoft.MachineLearningServices/workspaces/*/write'
          'Microsoft.Insights/alertRules/*'
          'Microsoft.Resources/deployments/*'
          'Microsoft.Search/searchServices/*'
          'Microsoft.Support/*'
          'Microsoft.Storage/storageAccounts/blobServices/containers/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/write'
          'Microsoft.DocumentDb/databaseAccounts/*'
        ]
        notActions: [
          'Microsoft.Search/searchServices/write'
          'Microsoft.Search/searchServices/delete'
          'Microsoft.Search/searchServices/listAdminKeys/action'
          'Microsoft.MachineLearningServices/workspaces/delete'
          'Microsoft.MachineLearningServices/workspaces/write'
          'Microsoft.MachineLearningServices/workspaces/listKeys/action'
          'Microsoft.MachineLearningServices/workspaces/hubs/write'
          'Microsoft.MachineLearningServices/workspaces/hubs/delete'
          'Microsoft.MachineLearningServices/workspaces/hubs/join/action'
          'Microsoft.MachineLearningServices/workspaces/featurestores/write'
          'Microsoft.MachineLearningServices/workspaces/featurestores/delete'
          'Microsoft.MachineLearningServices/workspaces/connections/deployments/write'
          'Microsoft.MachineLearningServices/workspaces/connections/deployments/delete'
          'Microsoft.MachineLearningServices/workspaces/connections/delete'
          'Microsoft.MachineLearningServices/workspaces/connections/write'
          'Microsoft.Resources/deployments/write'
          'Microsoft.Resources/deployments/delete'
          'Microsoft.Resources/deployments/cancel/action'
          'Microsoft.Resources/deployments/validate/action'
          'Microsoft.Resources/deployments/whatIf/action'
          'Microsoft.DocumentDB/databaseAccounts/dataTransferJobs/*'
          'Microsoft.DocumentDB/databaseAccounts/readonlyKeys/*'
          'Microsoft.DocumentDB/databaseAccounts/regenerateKey/*'
          'Microsoft.DocumentDB/databaseAccounts/listKeys/*'
          'Microsoft.DocumentDB/databaseAccounts/listConnectionStrings/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions/write'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions/delete'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments/write'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments/delete'
          'Microsoft.DocumentDB/databaseAccounts/mongodbRoleDefinitions/write'
          'Microsoft.DocumentDB/databaseAccounts/mongodbRoleDefinitions/delete'
          'Microsoft.DocumentDB/databaseAccounts/mongodbUserDefinitions/write'
          'Microsoft.DocumentDB/databaseAccounts/mongodbUserDefinitions/delete'
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
        notDataActions: [
          'Microsoft.CognitiveServices/accounts/FormRecognizer/custom/train/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/custom/models/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/documentmodels:build/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/documentmodels:build/write'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/creation/build/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/creation/classify/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/documentclassifiers:build/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/deployments/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/deployments/delete'
          'Microsoft.CognitiveServices/accounts/OpenAI/fine-tunes/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/fine-tunes/delete'
          'Microsoft.CognitiveServices/accounts/OpenAI/1p-jobs/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/1p-jobs/read'
        ]
      }
    ]
  }
}

// Custom Hub Owner Role
resource customHubOwner 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, 'Custom Hub Owner')
  properties: {
    roleName: 'Custom Hub Owner'
    description: 'Custom role-based access control for Hub Owners in AI Studio'
    assignableScopes: [
      subscription().id
    ]
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/roleAssignments/write'
          'Microsoft.Authorization/roleAssignments/delete'
          'Microsoft.MachineLearningServices/workspaces/hubs/write'
          'Microsoft.MachineLearningServices/workspaces/hubs/delete'
          'Microsoft.DocumentDB/databaseAccounts/dataTransferJobs/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions/write'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions/delete'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments/write'
          'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments/delete'
          'Microsoft.DocumentDB/databaseAccounts/mongodbRoleDefinitions/write'
          'Microsoft.DocumentDB/databaseAccounts/mongodbRoleDefinitions/delete'
          'Microsoft.DocumentDB/databaseAccounts/mongodbUserDefinitions/write'
          'Microsoft.DocumentDB/databaseAccounts/mongodbUserDefinitions/delete'
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
        notDataActions: [
          'Microsoft.CognitiveServices/accounts/FormRecognizer/custom/train/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/custom/models/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/documentmodels:build/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/documentmodels:build/write'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/creation/build/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/creation/classify/action'
          'Microsoft.CognitiveServices/accounts/FormRecognizer/documentclassifiers:build/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/deployments/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/deployments/delete'
          'Microsoft.CognitiveServices/accounts/OpenAI/fine-tunes/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/fine-tunes/delete'
          'Microsoft.CognitiveServices/accounts/OpenAI/1p-jobs/write'
          'Microsoft.CognitiveServices/accounts/OpenAI/1p-jobs/read'
        ]
      }
    ]
  }
}

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
