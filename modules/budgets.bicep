targetScope = 'resourceGroup'

param actionGroups_AIBudgetCostControlAlert_name string = 'AIBudgetCostControlAG'
param email_for_notifications string
param budgetName string = 'AIBudgetAlert'
param resetPeriod string = 'Monthly'
param budgetStartDate string = '2024-01-10T00:00:00Z'
param budgetAmount int = 100
param actionGroupName string = 'AIBudgetCostControlAlert'
param resourceGroupName string = resourceGroup().name

resource actionGroups_AIBudgetCostControlAlert_name_resource 'microsoft.insights/actionGroups@2023-09-01-preview' = {
  name: actionGroups_AIBudgetCostControlAlert_name
  location: 'Global'
  properties: {
    groupShortName: 'AIStudio'
    enabled: true
    emailReceivers: [
      {
        name: 'CostManagementTeam_-EmailAction-'
        emailAddress: email_for_notifications
        useCommonAlertSchema: false
      }
    ]
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: []
  }
}


 
resource budget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: budgetName
  properties: {
    category: 'Cost'
    amount: budgetAmount
    timeGrain: resetPeriod
    timePeriod: {
      startDate: budgetStartDate
    }
    notifications: {
      Actual_GreaterThan_80_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        contactEmails: []
        contactGroups: [
          resourceId('Microsoft.Insights/actionGroups', resourceGroupName, actionGroupName)
        ]
        contactRoles: []
        thresholdType: 'Actual'
      }
    }
  }
}
