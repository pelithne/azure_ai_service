param name string
param location string
param workspaceId string
param tags object

resource app_insights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'web'

  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
  }
  tags: tags
}

output id string = app_insights.id
