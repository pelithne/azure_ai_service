param name string
param location string
param tags object

resource ai_service_account 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: name
    publicNetworkAccess: 'Enabled'
  }
}

output id string = ai_service_account.id 
