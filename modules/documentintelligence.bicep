param name string
param location string
param tags object

resource document_intelligence 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'FormRecognizer'

  properties: {
    customSubDomainName: name
    publicNetworkAccess: 'Enabled'
  }
  tags: tags
}

output id string = document_intelligence.id



