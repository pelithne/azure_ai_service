targetScope = 'subscription'

// Parameters for the policy assignment
param assignmentName string = 'restrictModelRegistryDeploymentsAssignment'
param allowedRegistryName string = ''
param restrictedModels array = []
param location string
param listOfDeniedVMSizes array


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
        effect: 'Deny'
      }
    }
    parameters: {}
  }
}

// Assign the blockAzureOpenAI policy to the subscription
resource blockAzureOpenAIDeploymentsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'blockAzureOpenAIDeploymentsAssignment'
  properties: {
    displayName: 'Block Azure OpenAI Deployments Assignment'
    policyDefinitionId: blockAzureOpenAIDeployments.id
  }
}



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
        effect: 'Deny'
      }
    }
  }
}

// Assign the blockMachineLearningSKU policy to the subscription
resource blockMachineLearningSKUAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'blockMachineLearningSKUAssignment'
  properties: {
    displayName: 'blockMachineLearningSKU Assignment'
    policyDefinitionId: blockMachineLearningSKU.id
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
        effect: 'Deny'
      }
    }
    parameters: {}
  }
}

// Assign the commitment plan policy to the subscription
resource denyCommitmentPlanAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'denyCommitmentPlanAssignment'
  properties: {
    displayName: 'Deny commitmentplan Assignment'
    policyDefinitionId: denyCommitmentPlan.id
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
        effect: 'Deny'
      }
    }
    parameters: {}
  }
}

// Assign the blockAIStudio policy to the subscription
resource blockAIStudioHubCreationAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'blockAIStudioHubCreationAssignment'
  properties: {
    displayName: 'Block AI Studio Hub Creation Assignment'
    policyDefinitionId: blockAIStudioHubCreation.id
  }
}

// Assignment of built in policy
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: assignmentName
  location: location
  properties: {
    displayName: '[Preview]: Azure Machine Learning Model Registry Deployments are restricted except for the allowed Registry'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/19539b54-c61e-4196-9a38-67598701be90'
    parameters: {
      allowedRegistryName: {
        value: allowedRegistryName
      }
      restrictedModels: {
        value: restrictedModels
      }
      effect: {
        value: 'Deny'
      }
    }
  }
}
