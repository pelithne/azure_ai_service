param parentResourceId string
param openAiModelName string
param openAiModelVersion string
param embeddingModelName string
param embeddingModelVersion string
param skuName string
param skuCapacity int

resource openai 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: parentResourceId
}

resource openai_model_deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openai
  name: openAiModelName
  properties: {
    model: {
      format: 'OpenAI'
      name: openAiModelName
      version: openAiModelVersion
    }
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource embedding_model_deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openai
  name: embeddingModelName
  properties: {
    model: {
      format: 'OpenAI'
      name: embeddingModelName
      version: embeddingModelVersion
    }
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  dependsOn: [openai_model_deployment]
}

output openaiModelDeploymentId string = openai_model_deployment.id
output embeddingModelDeploymentId string = embedding_model_deployment.id