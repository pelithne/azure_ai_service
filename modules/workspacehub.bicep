param name string
param location string
param tags object
param storageAccountId string
param keyVaultId string
param discoveryUrl string
param defaultWorkspaceResourceGroup string

resource workspace_hub 'Microsoft.MachineLearningServices/workspaces@2024-07-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  kind: 'Hub'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: name
    storageAccount: storageAccountId
    keyVault: keyVaultId
    hbiWorkspace: false
    managedNetwork: {
      isolationMode: 'Disabled'
    }
    allowRoleAssignmentOnRG: true
    v1LegacyMode: false
    publicNetworkAccess: 'Enabled'
    ipAllowlist: []
    discoveryUrl: discoveryUrl
    enableSoftwareBillOfMaterials: false
    workspaceHubConfig: {
      defaultWorkspaceResourceGroup: defaultWorkspaceResourceGroup
    }
    enableDataIsolation: true
    systemDatastoresAuthMode: 'accesskey'
    enableServiceSideCMKEncryption: false
  }
}

output name string = workspace_hub.name

// Output the principal IDs
output principalId string = workspace_hub.identity.principalId
