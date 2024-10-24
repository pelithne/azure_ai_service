// Parameters with default values. These can be overridden at deployment time using the -p flag.

@description('The base name which should only contain lowercase characters (a to z).')
param base_name string = 'abcdefghijklmnopqrstuvxyz'

@description('The location where the resources will be deployed.')
param location string = resourceGroup().location

// Automatically set base_name tag to the base name (for testing purposes)
@description('Tags to be applied to the resources.')
param tags object = {base_name: base_name}

@description('List of VM sizes that are denied for deployment.')
param listOfDeniedVMSizes array = []

// Variables
var vaults_kv_name = '${base_name}keyvault'
var storage_name = '${base_name}storage'
var accounts_name = '${base_name}aoai'
var hub_resource_name = '${base_name}workspacehub'
var ai_service_resource_name = '${base_name}azureai'
var search_service_resource_name = '${base_name}searchservices'
var cosmosdb_account_name = '${base_name}cosmosdb'
var app_insights_name = '${base_name}appinsights'
var log_analytics_workspace_name = '${base_name}loganalytics'
var discovery_url = 'https://${location}.api.azureml.ms/discovery'
var defaultWorkspaceResourceGroup = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}'
var policy_assignment_name = '${base_name}policyassignment'

// Modules

// Deploys a Log Analytics workspace with the specified name and tags
module logAnalyticsWorkspace 'modules/loganalyticsworkspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    name: log_analytics_workspace_name
    location: location
    tags: tags
  }
}

// Deploys an Application Insights instance with the specified name and tags
module appInsights 'modules/appinsights.bicep' = {
  name: 'appInsights'
  params: {
    name: app_insights_name
    location: location
    workspaceId: logAnalyticsWorkspace.outputs.id
    tags: tags
  }
}

// Deploys a Cosmos DB account with the specified name and tags
module cosmosdbAccount 'modules/cosmosdbaccount.bicep' = {
  name: 'cosmosdbAccount'
  params: {
    name: cosmosdb_account_name
    location: location
    tags: tags
  }
}

// Deploys a Storage Account with the specified name and tags
module storageAccount 'modules/storageaccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    storage_name: storage_name
    location: location
    tags: tags
  }
}

// Deploys a Key Vault with the specified name and tags
module keyVault 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    vaults_kv_name: vaults_kv_name
    location: location
    tags: tags
  }
}

// Deploys a Workspace Hub with the specified name and tags
module workspaceHub 'modules/workspacehub.bicep' = {
  name: 'workspaceHub'
  params: {
    name: hub_resource_name
    location: location
    tags: tags
    storageAccountId: storageAccount.outputs.id
    keyVaultId: keyVault.outputs.id
    discoveryUrl: discovery_url
    defaultWorkspaceResourceGroup: defaultWorkspaceResourceGroup
  }
}

// Deploys an Azure AI service account with the specified name and tags
module aiServiceAccount 'modules/aiserviceaccount.bicep' = {
  name: 'aiServiceAccount'
  params: {
    name: ai_service_resource_name
    location: location
    tags: tags
  }
}

// Deploys an Azure Cognitive Search service with the specified name and tags
module searchService 'modules/searchservice.bicep' = {
  name: 'searchService'
  params: {
    name: search_service_resource_name
    location: location
    tags: tags
  }
}

// Creates connections between the Workspace Hub and other services
module hubConnections 'modules/hubconnections.bicep' = {
  name: 'hubConnectiondocintelligence'
  params: {
    parentResourceId: hub_resource_name
    accountsName: accounts_name
    aiSearchResourceId: searchService.outputs.id
    aiServiceResourceId: aiServiceAccount.outputs.id
    aiSearchName: search_service_resource_name
    aiServiceName: 'azureai'
    location: location
    tags: tags
  }
  dependsOn: [workspaceHub]
}

// Deploys model deployments for the AI service
module modelDeployments 'modules/modeldeployments.bicep' = {
  name: 'modelDeployments'
  params: {
    parentResource: ai_service_resource_name
    tags: tags
  }
  dependsOn: [aiServiceAccount]
}

// Enables Microsoft Defender for all resources at the subscription level
module microsoftDefender 'modules/microsoft-defender.bicep' = {
  name: 'microsoftDefender'
  scope: subscription()
  params: {
    tags: tags
  }
}

// Creates custom roles at the subscription level
module customRoles 'modules/customroles.bicep' = {
  name: 'customRoles'
  scope: subscription()
  params: {
    tags: tags
  }
}

// Defines custom policies at the subscription level, including a deny list for VM sizes
module policyDefinitions 'modules/customPolicies.bicep' = {
  name: 'policies'
  scope: subscription()
  params: {
    tags: tags
    listOfDeniedVMSizes: listOfDeniedVMSizes
  }
  dependsOn: [
    workspaceHub, aiServiceAccount, searchService, hubConnections, modelDeployments
  ]
}

// Assigns the defined policies to the resource group
module policyAssignments 'modules/policyAssignments.bicep' = {
  name: 'policyAssignments'
  scope: resourceGroup()
  params: {
    assignmentName: policy_assignment_name
    allowedRegistryName: ''
    restrictedModels: []
    location: location
    blockAzureOpenAIDeploymentsId: policyDefinitions.outputs.blockAzureOpenAIDeploymentsId
    blockMachineLearningSKUId: policyDefinitions.outputs.blockMachineLearningSKUId
    denyCommitmentPlanId: policyDefinitions.outputs.denyCommitmentPlanId
    blockAIStudioHubCreationId: policyDefinitions.outputs.blockAIStudioHubCreationId
  }
}

// Assigns roles to various services and resources
module roleAssignment 'modules/roleassignments.bicep' = {
  name: 'roleAssignment'
  params: {
    storageAccountName: storage_name
    aiServicesPrincipalId: aiServiceAccount.outputs.principalId
    searchServicesPrincipalId: searchService.outputs.principalId
    hubPrincipalId: workspaceHub.outputs.principalId
    searchServiceName: searchService.name
    aiServiceName: aiServiceAccount.name
    tags: tags
  }
  dependsOn: [
    workspaceHub, aiServiceAccount, searchService, hubConnections, modelDeployments
  ]
}
