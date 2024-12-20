param name string
param location string
param tags object

resource search_service 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'standard'
  }
  identity: {
    type: 'SystemAssigned'
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
    disableLocalAuth: true
    authOptions: null
    disabledDataExfiltrationOptions: []
    semanticSearch: 'disabled'
  }
}

output id string = search_service.id
// output search service principalId
output principalId string = search_service.identity.principalId 
