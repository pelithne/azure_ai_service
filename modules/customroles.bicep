// Parameters
param location string

// Variables
var roleName = 'projectmembernot-pelithne'
var roleDescription = 'notActions and noDataActions for a project member'
var roleActions = []
var roleNotActions = [
  'Microsoft.CognitiveServices/accounts/listKeys/action'
  'Microsoft.Storage/storageAccounts/blobServices/containers/delete'
  'Microsoft.CognitiveServices/accounts/commitmentplans/read'
  'Microsoft.CognitiveServices/accounts/commitmentplans/write'
  'Microsoft.CognitiveServices/accounts/commitmentplans/delete'
  'Microsoft.Resources/deployments/write'
  'Microsoft.Resources/deployments/delete'
  'Microsoft.Resources/deployments/cancel/action'
  'Microsoft.MachineLearningServices/workspaces/hubs/write'
  'Microsoft.MachineLearningServices/workspaces/hubs/delete'
  'Microsoft.MachineLearningServices/workspaces/hubs/join/action'
  'Microsoft.MachineLearningServices/workspaces/modules/write'
  'Microsoft.MachineLearningServices/workspaces/connections/deployments/write'
  'Microsoft.MachineLearningServices/workspaces/connections/deployments/delete'
  'Microsoft.MachineLearningServices/workspaces/connections/delete'
  'Microsoft.MachineLearningServices/workspaces/connections/write'
  'Microsoft.CognitiveServices/accounts/deployments/write'
  'Microsoft.CognitiveServices/accounts/deployments/delete'
  'Microsoft.MachineLearningServices/workspaces/endpoints/deployments/write'
  'Microsoft.MachineLearningServices/workspaces/endpoints/deployments/delete'
  'Microsoft.MachineLearningServices/workspaces/listConnectionModels/action'
  'Microsoft.CognitiveServices/accounts/deployments/read'
  'Microsoft.MachineLearningServices/workspaces/endpoints/deployments/read'
]
var roleDataActions = []
var roleNotDataActions = [
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
var roleAssignableScopes = [
  '/subscriptions/4ce7ad8d-95ed-4652-bd4a-5f2af19d29cb'
]

// Resource: Custom Role Definition
resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().subscriptionId, roleName)
  properties: {
    roleName: roleName
    description: roleDescription
    type: 'CustomRole'
    permissions: [
      {
        actions: roleActions
        notActions: roleNotActions
        dataActions: roleDataActions
        notDataActions: roleNotDataActions
      }
    ]
    assignableScopes: roleAssignableScopes
  }
}

// Outputs
output roleDefinitionId string = customRole.id
