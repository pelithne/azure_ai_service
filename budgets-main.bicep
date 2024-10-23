// Call the budgets module
param budgetAmount int

param email_for_notifications string = 'example@mail.se'

module budget 'modules/budgets.bicep' = {
  name: 'budget'
  scope: resourceGroup()
  params: {
    budgetName: '${resourceGroup().name}-budget'
    budgetAmount: budgetAmount
    budgetStartDate: '2024-01-10T00:00:00Z'
    email_for_notifications: email_for_notifications
    actionGroups_AIBudgetCostControlAlert_name: '${resourceGroup().name}-AIBudgetCostControlAG}'
  }
}
