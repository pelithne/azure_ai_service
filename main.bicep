// Parameters with default values. These can be overridden at deployment time using the -p flag.S
param base_name string = 'pelithne'
param tags object = {}
param location string = resourceGroup().location

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

// Modules
module logAnalyticsWorkspace 'modules/loganalyticsworkspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    name: log_analytics_workspace_name
    location: location
    tags: tags
  }
}

module appInsights 'modules/appinsights.bicep' = {
  name: 'appInsights'
  params: {
    name: app_insights_name
    location: location
    workspaceId: logAnalyticsWorkspace.outputs.id
    tags: tags
  }
}

module cosmosdbAccount 'modules/cosmosdbaccount.bicep' = {
  name: 'cosmosdbAccount'
  params: {
    name: cosmosdb_account_name
    location: location
    tags: tags
  }
}

module storageAccount 'modules/storageaccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    storage_name: storage_name
    location: location
  }
}

module keyVault 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    vaults_kv_name: vaults_kv_name
    location: location
  }
}

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

module aiServiceAccount 'modules/aiserviceaccount.bicep' = {
  name: 'aiServiceAccount'
  params: {
    name: ai_service_resource_name
    location: location
    tags: tags
  }
}

module searchService 'modules/searchservice.bicep' = {
  name: 'searchService'
  params: {
    name: search_service_resource_name
    location: location
    tags: tags
  }
}

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
  }
  dependsOn: [workspaceHub]
}

module modelDeployments 'modules/modeldeployments.bicep' = {
  name: 'modelDeployments'
  params: {
    parentResource: ai_service_resource_name
    openAiModelName: 'gpt-4o'
    openAiModelVersion: '2024-08-06'
    embeddingModelName: 'text-embedding-ada-002'
    embeddingModelVersion: '2'
    skuName: 'Standard'
    skuCapacity: 2
  }
  dependsOn: [aiServiceAccount]
}

/*
// Include custom roles module
module customRoles 'modules/customroles.bicep' = {
  name: 'customRoles'
  params: {
    location: location
  }
}
*/
