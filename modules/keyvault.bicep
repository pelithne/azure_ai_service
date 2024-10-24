param vaults_kv_name string
param location string
param tags object

resource vaults_kv_resource 'Microsoft.KeyVault/vaults@2023-07-01' = {
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
