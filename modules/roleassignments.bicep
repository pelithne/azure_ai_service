targetScope = 'resourceGroup'

// Parameters
param storageAccountName string
param aiServicesPrincipalId string
param searchServicesPrincipalId string
param hubPrincipalId string
param searchServiceName string

// Reference the existing storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
}

// Reference the existing search service
resource searchService 'Microsoft.Search/searchServices@2020-08-01' existing = {
  name: searchServiceName
}

// Role Assignment for AI Services to be Storage Blob Data Contributor
resource storageBlobDataContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, 'Storage Blob Data Contributor', aiServicesPrincipalId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Contributor
    principalId: aiServicesPrincipalId
  }
}

// Role Assignment for Search Service to be Storage Blob Data Reader
resource storageBlobDataReaderAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, 'Storage Blob Data Reader', searchServicesPrincipalId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1') // Storage Blob Data Reader
    principalId: searchServicesPrincipalId
  }
}

// Role Assignment for Hub to be Search Service Contributor on Search Service
resource searchServiceContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(searchService.id, 'Search Service Contributor', hubPrincipalId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0') // Search Service Contributor
    principalId: hubPrincipalId
  }
}

// Role Assignment for Hub to be Search Index Data Contributor on Search Service
resource searchIndexDataContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(searchService.id, 'Search Index Data Contributor', hubPrincipalId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8ebe5a00-799e-43f5-93ac-243d3dce84a7') // Search Index Data Contributor
    principalId: hubPrincipalId
  }
}
