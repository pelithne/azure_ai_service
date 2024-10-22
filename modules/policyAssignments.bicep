targetScope = 'resourceGroup'

// Parameters for the policy assignment
param assignmentName string 
param allowedRegistryName string
param restrictedModels array
param location string
param blockAzureOpenAIDeploymentsId string
param blockMachineLearningSKUId string
param denyCommitmentPlanId string
param blockAIStudioHubCreationId string

// Assign the blockAzureOpenAI policy to the subscription
resource blockAzureOpenAIDeploymentsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'blockAzureOpenAIDeploymentsAssignment'
  properties: {
    displayName: 'Block Azure OpenAI Deployments Assignment'
    policyDefinitionId: blockAzureOpenAIDeploymentsId
  }
}

// Assign the blockMachineLearningSKU policy to the subscription
resource blockMachineLearningSKUAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'blockMachineLearningSKUAssignment'
  properties: {
    displayName: 'blockMachineLearningSKU Assignment'
    policyDefinitionId: blockMachineLearningSKUId
  }
}

// Assign the commitment plan policy to the subscription
resource denyCommitmentPlanAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'denyCommitmentPlanAssignment'
  properties: {
    displayName: 'Deny commitmentplan Assignment'
    policyDefinitionId: denyCommitmentPlanId
  }
}

// Assign the blockAIStudio policy to the subscription
resource blockAIStudioHubCreationAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'blockAIStudioHubCreationAssignment'
  properties: {
    displayName: 'Block AI Studio Hub Creation Assignment'
    policyDefinitionId: blockAIStudioHubCreationId
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
