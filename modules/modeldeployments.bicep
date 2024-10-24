param parentResource string
param tags object

resource azureai 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: parentResource
}

resource gpt_4o_model_deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: azureai
  name: 'gpt-4o-global'
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: '2024-08-06'
    }
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource gpt_4o_mini_model_deployment 'Microsoft.CognitiveServices/accounts/deployments@2024-06-01-preview' = {
  parent: azureai
  name: 'gpt-4o-mini-global'
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o-mini'
      version: '2024-07-18'
    }
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
  dependsOn: [gpt_4o_model_deployment]
}

resource embedding_model_deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: azureai
  name: 'text-embedding-ada-002'
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '2'
    }
  }
  sku: {
    name: 'Standard'
    capacity: 1
  }
  dependsOn: [gpt_4o_mini_model_deployment]
}
