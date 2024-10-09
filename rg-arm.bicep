param iteration string = '18'
param baseName string = 'abpl${iteration}'
param vaults_kv_name string = '${baseName}abplkvpelithne'
param workspaces_abpl_hub_name string = '${baseName}hubpelithne'
param searchServices_storage_name string = '${baseName}abplstoragepelithne'
param accounts_name string = '${baseName}aoaipelithne'
param storage_account_sku string = 'Standard_GRS'
param ai_service_sku string = 'S0'
param search_service_sku string = 'standard'
param hub_sku string = 'Basic'
param location string = 'swedencentral'

var discoveryURL = 'https://${location}.api.azureml.ms/discovery'
var hubresourceName = '${baseName}workspaces_hub'
var aiServiceResourceName = '${baseName}accountsaoai'
var searchServiceResourceName = '${baseName}searchservices'


var defaultWorkspaceResourceGroup = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}'


resource accounts_resource 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: aiServiceResourceName
  location: location
  sku: {
    name: ai_service_sku
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: aiServiceResourceName
    publicNetworkAccess: 'Enabled'
  }
}

resource vaults_kv_resource 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
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

resource searchServices_resource 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: searchServiceResourceName
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

resource searchServices_storage_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: searchServices_storage_name
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

resource accounts_name_Default 'Microsoft.CognitiveServices/accounts/defenderForAISettings@2024-06-01-preview' = {
  parent: accounts_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource workspaces_hub_resource 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' = {
  name: hubresourceName
  location: location
  tags: { }
  sku: {
    name: hub_sku
    tier: hub_sku
  }
  kind: 'Hub'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: workspaces_abpl_hub_name
    storageAccount: searchServices_storage_resource.id
    keyVault: vaults_kv_resource.id
    hbiWorkspace: false
    managedNetwork: {
      isolationMode: 'Disabled'
    }
    allowRoleAssignmentOnRG: true
    v1LegacyMode: false
    publicNetworkAccess: 'Enabled'
    ipAllowlist: []
    discoveryUrl: discoveryURL
    enableSoftwareBillOfMaterials: false
    workspaceHubConfig: {
      defaultWorkspaceResourceGroup: defaultWorkspaceResourceGroup
    }
    enableDataIsolation: true
    systemDatastoresAuthMode: 'accesskey'
    enableServiceSideCMKEncryption: false
  }
}

resource hub_connection_csvc 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspaces_hub_resource
  name: 'csvc-connection'
  properties: {
    authType: 'AAD'
    category: 'AIServices'
    target: 'https://${accounts_name}.cognitiveservices.azure.com/'
    useWorkspaceManagedIdentity: true
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: accounts_resource.id
      location: location
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
    }
  }
}

resource hub_connection_openai 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspaces_hub_resource
  name: 'openai-connection'
  properties: {
    authType: 'AAD'
    category: 'AzureOpenAI'
    target: 'https://${accounts_name}.openai.azure.com/'
    useWorkspaceManagedIdentity: true
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: accounts_resource.id
      location: location
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
    }
  }
}

resource hub_connection_azureai_earch 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
  parent: workspaces_hub_resource
  name: 'aisearch-connection'
  properties: {
    authType: 'AAD'
    category: 'CognitiveSearch'
    target: 'https://${accounts_name}.search.windows.net'
    useWorkspaceManagedIdentity: false
    isSharedToAll: true
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: searchServices_resource.id
      location: location
      ApiVersion: '2024-05-01-preview'
      DeploymentApiVersion: '2023-11-01'
    }
  }
}
