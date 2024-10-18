param vaults_kv_name string
param location string

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
    enableRbacAuthorization: true
  }
}


output id string = vaults_kv_resource.id
