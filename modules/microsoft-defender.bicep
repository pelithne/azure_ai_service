targetScope = 'subscription'

resource StorageAccounts 'Microsoft.Security/pricings@2023-01-01' = {
  name: 'StorageAccounts'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'DefenderForStorageV2'
    extensions: [
      {
        name: 'OnUploadMalwareScanning'
        isEnabled: 'True'
        additionalExtensionProperties: {
          CapGBPerMonthPerStorageAccount: '5000'
        }
      }
      {
        name: 'SensitiveDataDiscovery'
        isEnabled: 'True'
      }
    ]
  }
}

// Enable Microsoft Defender for Key Vault
resource keyVaultDefender 'Microsoft.Security/pricings@2023-01-01' = {
  name: 'KeyVaults'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'PerTransaction'
    extensions: []
  }
}

// Enable Microsoft Defender for Cosmos DB
resource cosmosDbDefender 'Microsoft.Security/pricings@2023-01-01' = {
  name: 'SqlServers'
  properties: {
    pricingTier: 'Standard'
    extensions: []
  }
}

/*
resource aiProtectionDefender 'Microsoft.Security/pricings@2023-01-01' = {
  name: 'CognitiveServices'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'DefenderForAI'
    extensions: []
  }
}
*/
output keyVaultDefenderId string = keyVaultDefender.id
output cosmosDbDefenderId string = cosmosDbDefender.id
