param name string
param location string
param tags object

resource cosmosdb_account 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: name
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
  tags: tags
}


output id string = cosmosdb_account.id
