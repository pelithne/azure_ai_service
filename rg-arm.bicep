param iteration string = '15'
param vaults_kv_name string = 'kvabplhubpelithne${iteration}'
param workspaces_abpl_hub_name string = 'abplhubpelithne${iteration}'
param searchServices_abpl_name string = 'abplsearchpelithne${iteration}'
param searchServices_abpl_search_name string = 'stabplhubpelithne${iteration}'
param accounts_abpl_aoai_name string = 'abplaoaipelithne${iteration}'
param storage_account_sku string = 'Standard_GRS'
param ai_service_sku string = 'S0'
param search_service_sku string = 'standard'

param location string = 'swedencentral'


resource accounts_abpl_aoai_name_resource 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: accounts_abpl_aoai_name
  location: location
  sku: {
    name: ai_service_sku
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: accounts_abpl_aoai_name
    publicNetworkAccess: 'Enabled'
  }
}

resource vaults_kv_name_resource 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: vaults_kv_name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '1758a79e-7b9d-4949-b202-930c3c29a179'
    accessPolicies: [
      {
        tenantId: '1758a79e-7b9d-4949-b202-930c3c29a179'
        objectId: '76e1a2b7-ecc4-4074-94af-3ea5d6df1d4d'
        permissions: {
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
          certificates: [
            'all'
          ]
          storage: []
        }
      }
    ]
    enabledForDeployment: false
    vaultUri: 'https://${vaults_kv_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}

resource searchServices_abpl_name_resource 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: searchServices_abpl_name
  location: location
  sku: {
    name: search_service_sku
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      ipRules: []
      bypass: 'None'
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
    disabledDataExfiltrationOptions: []
    semanticSearch: 'disabled'
  }
}

resource searchServices_abpl_search_name_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: searchServices_abpl_search_name
  location: location
  sku: {
    name: storage_account_sku
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource accounts_abpl_aoai_name_Default 'Microsoft.CognitiveServices/accounts/defenderForAISettings@2024-06-01-preview' = {
  parent: accounts_abpl_aoai_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}


resource searchServices_abpl_search_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: searchServices_abpl_search_name_resource
  name: 'default'
  sku: {
    name: storage_account_sku
    tier: 'Standard'
  }
  properties: {
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
      ]
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_searchServices_abpl_search_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: searchServices_abpl_search_name_resource
  name: 'default'
  sku: {
    name: storage_account_sku
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
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
          ]
          maxAgeInSeconds: 1800
          exposedHeaders: [
            '*'
          ]
          allowedHeaders: [
            '*'
          ]
        }
      ]
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_searchServices_abpl_search_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: searchServices_abpl_search_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_searchServices_abpl_search_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-05-01' = {
  parent: searchServices_abpl_search_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource workspaces_abpl_hub_name_resource 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' = {
  name: workspaces_abpl_hub_name
  location: location
  tags: { }
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  kind: 'Hub'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: workspaces_abpl_hub_name
    storageAccount: searchServices_abpl_search_name_resource.id
    keyVault: vaults_kv_name_resource.id
    hbiWorkspace: false
    managedNetwork: {
      isolationMode: 'Disabled'
    }
    allowRoleAssignmentOnRG: true
    v1LegacyMode: false
    publicNetworkAccess: 'Enabled'
    ipAllowlist: []
    discoveryUrl: 'https://swedencentral.api.azureml.ms/discovery'
    enableSoftwareBillOfMaterials: false
    workspaceHubConfig: {
      defaultWorkspaceResourceGroup: '/subscriptions/4ce7ad8d-95ed-4652-bd4a-5f2af19d29cb/resourceGroups/rg-ericsson-ai-studio'
    }
    enableDataIsolation: true
    systemDatastoresAuthMode: 'accesskey'
    enableServiceSideCMKEncryption: false
  }
}

resource workspaces_abpl_hub_name_abpl_aoai191036897597 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspaces_abpl_hub_name_resource
  name: 'abpl-aoai191036897597'
  properties: {
    authType: 'AAD'
    category: 'AIServices'
    target: 'https://${accounts_abpl_aoai_name}.cognitiveservices.azure.com/'
    useWorkspaceManagedIdentity: true
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: accounts_abpl_aoai_name_resource.id
      location: location
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
    }
  }
}

resource workspaces_abpl_hub_name_abpl_aoai191036897597_aoai 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspaces_abpl_hub_name_resource
  name: 'abpl-aoai191036897597_aoai'
  properties: {
    authType: 'AAD'
    category: 'AzureOpenAI'
    target: 'https://${accounts_abpl_aoai_name}.openai.azure.com/'
    useWorkspaceManagedIdentity: true
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: accounts_abpl_aoai_name_resource.id
      location: location
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
    }
  }
}

resource workspaces_abpl_hub_name_AzureAISearch 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspaces_abpl_hub_name_resource
  name: 'AzureAISearch'
  properties: {
    authType: 'AAD'
    category: 'CognitiveSearch'
    target: 'https://${accounts_abpl_aoai_name}.search.windows.net'
    useWorkspaceManagedIdentity: false
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: searchServices_abpl_name_resource.id
      location: location
      ApiVersion: '2024-05-01-preview'
      DeploymentApiVersion: '2023-11-01'
    }
  }
}
