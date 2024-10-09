param label string = '22'
param base_name string = 'abpl${label}'
param vaults_kv_name string = '${base_name}kvpelithne'
param workspaces_hub_name string = '${base_name}hubpelithne'
param ss_storage_name string = '${base_name}storagepelithne'
param accounts_name string = '${base_name}aoaipelithne'
param hub_resource_name string = '${base_name}workspaces_hub'
param ai_service_resource_name string = '${base_name}accountsaoai'
param search_service_resource_name string = '${base_name}searchservices'
param location string = 'swedencentral'

var discoveryURL = 'https://${location}.api.azureml.ms/discovery'
var defaultWorkspaceResourceGroup = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}'
var tenant_id = subscription().tenantId

resource accounts_resource 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: ai_service_resource_name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: ai_service_resource_name
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
    tenantId: tenant_id
    accessPolicies: []
  }
}

resource search_services_resource 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: search_service_resource_name
  location: location
  sku: {
    name: 'standard'
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

resource search_services_storage_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: ss_storage_name
  location: location
  sku: {
    name: 'Standard_GRS'
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

resource workspaces_hub_resource 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' = {
  name: hub_resource_name
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
    friendlyName: workspaces_hub_name
    storageAccount: search_services_storage_resource.id
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

resource hub_connection_azureai_search 'Microsoft.MachineLearningServices/workspaces/connections@2024-07-01-preview' = {
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
      ResourceId: search_services_resource.id
      location: location
      ApiVersion: '2024-05-01-preview'
      DeploymentApiVersion: '2023-11-01'
    }
  }
}
