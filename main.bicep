// Parameters
param base_name string
param location string
param tags object

// Variables
var vaults_kv_name = '${base_name}kvpelithne'
var workspaces_hub_name = '${base_name}hubpelithne'
var storage_name = '${base_name}storagepelithne'
var accounts_name = '${base_name}aoaipelithne'
var hub_resource_name = '${base_name}workspacehubpelithne'
var ai_service_resource_name = '${base_name}accountsaoai'
var openai_resource_name = '${base_name}openai'
var search_service_resource_name = '${base_name}searchservices'
var document_intelligence_name = '${base_name}docintelligence'
var cosmosdb_account_name = '${base_name}cosmosdb'
var app_insights_name = '${base_name}appinsights'
var log_analytics_workspace_name = '${base_name}loganalytics'
var discoveryURL = 'https://${location}.api.azureml.ms/discovery'
var defaultWorkspaceResourceGroup = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}'
var tenant_id = subscription().tenantId

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

module workspaceHub 'modules/workspacehub.bicep' = {
  name: 'workspaceHub'
  params: {
    name: hub_resource_name
    location: location
    tags: tags
    storageAccountId: storage_resource.id
    keyVaultId: vaults_kv_resource.id
    discoveryUrl: discoveryURL
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

module openAIResource 'modules/openairesource.bicep' = {
  name: openai_resource_name
  params: {
    name: openai_resource_name
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

module documentIntelligence 'modules/documentintelligence.bicep' = {
  name: 'documentIntelligence'
  params: {
    name: document_intelligence_name
    location: location
    tags: tags
  }
}

// Storage Account Resource
resource storage_resource 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storage_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// Key Vault Resource
resource vaults_kv_resource 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: vaults_kv_name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
  }
}


module hubConnectionCsvc 'modules/hubconnectioncsvc.bicep' = {
  name: 'hubConnectionCsvc'
  params: {
    parentResourceId: hub_resource_name
    accountsName: accounts_name
    aiServiceResourceId: aiServiceAccount.outputs.id
    location: location
  }
  dependsOn: [workspaceHub]
}

module hubConnectionopenai 'modules/hubconnectionopenai.bicep' = {
  name: 'hubConnectionopenai'
  params: {
    parentResourceId: hub_resource_name
    accountsName: accounts_name
    aoaiResourceId: openAIResource.outputs.id
    location: location
  }
  dependsOn: [workspaceHub]
}

module hubConnectionaisearch 'modules/hubconnectionaisearch.bicep' = {
  name: 'hubConnectionaisearch'
  params: {
    parentResourceId: hub_resource_name
    accountsName: accounts_name
    aiSearchResourceId: searchService.outputs.id
    location: location
  }
  dependsOn: [workspaceHub]
}

module hubConnectiondocintelligence 'modules/hubconnectiondocintelligence.bicep' = {
  name: 'hubConnectiondocintelligence'
  params: {
    parentResourceId: hub_resource_name
    accountsName: accounts_name
    docIntelligenceResourceId: documentIntelligence.outputs.id
    location: location
  }
  dependsOn: [workspaceHub]
}


module modelDeployments 'modules/modeldeployments.bicep' = {
  name: 'modelDeployments'
  params: {
    parentResourceId: openai_resource_name
    openAiModelName: 'gpt-4o'
    openAiModelVersion: '2024-08-06'
    embeddingModelName: 'text-embedding-ada-002'
    embeddingModelVersion: '2'
    skuName: 'Standard'
    skuCapacity: 2
  }
  dependsOn: [
    openAIResource
  ]
}
