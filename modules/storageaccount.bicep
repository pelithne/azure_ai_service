param storage_name string
param location string
param tags object

resource storage_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storage_name
  location: location
  sku: {
    name: 'Standard_ZRS'
  }
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}


resource storage_resource_blob 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storage_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    changeFeed: {
      enabled: true
    }
    restorePolicy: {
      enabled: true
      days: 1
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: [
        {
          allowedOrigins: [
            'https://mlworkspace.azure.ai'
            'https://ml.azure.com'
            'https://*.ml.azure.com'
            'https://ai.azure.com'
            'https://*.ai.azure.com'
          ]
          allowedMethods: [
            'GET'
            'HEAD'
            'PUT'
            'DELETE'
            'OPTIONS'
            'POST'
            'PATCH'
          ]
          maxAgeInSeconds: 1800
          exposedHeaders: [
            '*'
          ]
          allowedHeaders: [
            '*'
          ]
        }
        {
          allowedOrigins: [
            'https://documentintelligence.ai.azure.com'
          ]
          allowedMethods: [
            'DELETE'
            'GET'
            'HEAD'
            'MERGE'
            'OPTIONS'
            'PATCH'
            'POST'
            'PUT'
          ]
          maxAgeInSeconds: 120
          exposedHeaders: [
            '*'
          ]
          allowedHeaders: [
            '*'
          ]
        }
      ]
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    isVersioningEnabled: true
  }
}


output id string = storage_resource.id
