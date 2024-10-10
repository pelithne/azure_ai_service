param storage_name string
param location string

resource storage_resource 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storage_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output id string = storage_resource.id
