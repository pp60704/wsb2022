param location string
param hubname string

var logAnalyticsWorkspaceName = 'lg-${hubname}-prod-${location}-01'
// var logAnalyticsWorkspaceName = uniqueString(subscription().subscriptionId, resourceGroup().id)

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output loganalyticsid string = logAnalyticsWorkspace.id
