targetScope = 'subscription'

// Block Azure OpenAI Deployments
resource blockAzureOpenAIDeployments 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'blockAzureOpenAIDeployments pelithne'
  properties: {
    displayName: 'Block Azure OpenAI Deployments'
    mode: 'All'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.CognitiveServices/accounts/deployments'
      }
      then: {
        effect: 'deny'
      }
    }
    parameters: {}
  }
}



param listOfDeniedVMSizes array

// Block Machine Learning SKU
resource blockMachineLearningSKU 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'blockMachineLearningSKU pelithne'
  properties: {
    displayName: 'Block Machine Learning SKU'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.MachineLearningServices/workspaces/computes'
          }
          {
            field: 'Microsoft.MachineLearningServices/workspaces/computes/vmSize'
            in: listOfDeniedVMSizes
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}



// Deny commitmentplan
resource denyCommitmentPlan 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'denyCommitmentPlan pelithne'
  properties: {
    displayName: 'Deny commitmentplan'
    mode: 'All'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.CognitiveServices/accounts/commitmentPlans'
      }
      then: {
        effect: 'deny'
      }
    }
    parameters: {}
  }
}

// Block AI Studio Hub Creation
resource blockAIStudioHubCreation 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'blockAIStudioHubCreation pelithne'
  properties: {
    displayName: 'Block AI Studio Hub Creation'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.MachineLearningServices/workspaces'
          }
          {
            field: 'kind'
            equals: 'Hub'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
    parameters: {}
  }
}

