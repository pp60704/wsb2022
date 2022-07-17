param hubname string
param location string
param loganalyticsid string
param virtualNetworks_vnet_hub_subnets string = 'vnet-${hubname}-prod-${location}-01'

resource virtualNetworks_vnet_hub_net0_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_vnet_hub_subnets
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    // dhcpOptions:{
    //   dnsServers:[
    //     '192.168.88.90'
    //     '192.168.88.91'
    //   ]
    // }
    subnets: [
      {
        name: 'subnet01'
        properties: {
          addressPrefix: '172.16.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }


    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_hub_net0_name_subnet01 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_hub_net0_resource
  name: 'subnet01'
  properties: {
    addressPrefix: '172.16.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn:[
    virtualNetworks_vnet_hub_net0_resource
  ]
}

resource virtualNetworks_vnet_hub_net0_name_Bastion 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_hub_net0_resource
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: '172.16.251.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn:[
    virtualNetworks_vnet_hub_net0_GatewaySubnet
  ]
}
resource virtualNetworks_vnet_hub_net0_name_Firewall 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_hub_net0_resource
  name: 'AzureFirewallSubnet'
  properties: {
    addressPrefix: '172.16.252.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn:[
    virtualNetworks_vnet_hub_net0_name_Bastion
  ]
}

resource virtualNetworks_vnet_hub_net0_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_hub_net0_resource
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: '172.16.254.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn:[
    virtualNetworks_vnet_hub_net0_name_subnet01
  ]
}

resource diagVnetHub 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagVnetHub'
  scope: virtualNetworks_vnet_hub_net0_resource
  properties: {
    workspaceId: loganalyticsid
    logs: [
      {
        category: 'VMProtectionAlerts'
        enabled: true
      }
    ]
  }
}

output subnetgwid string = virtualNetworks_vnet_hub_net0_GatewaySubnet.id
output subnetafwid string = virtualNetworks_vnet_hub_net0_name_Firewall.id
output subnetbastionid string = virtualNetworks_vnet_hub_net0_name_Bastion.id
output subnetid string = virtualNetworks_vnet_hub_net0_name_subnet01.id
