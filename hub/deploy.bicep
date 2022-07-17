param location string = resourceGroup().location
param hubname string = 'hub'

module loganalytics 'loganalytics.bicep' = {
  name: 'loganalitycshub'
  params:{
    location: location
    hubname: hubname
  }  
  dependsOn:[]
}


module vnetHub 'vnethub.bicep' = {
  name: 'vnethub'
  params:{
    location: location
    hubname: hubname
    loganalyticsid: loganalytics.outputs.loganalyticsid
  }
  dependsOn:[loganalytics]
}

module vpnGW 'vpngw.bicep' = {
  name: 'vpngwhub'
  params:{
    location: location
    hubname: hubname
    subnetgwid: vnetHub.outputs.subnetgwid
    loganalyticsid: loganalytics.outputs.loganalyticsid
  }  
  dependsOn:[
    vnetHub
  ]
}

module hubbastion 'bastion.bicep' = {
  name: 'bastionhub'
  params:{
    location: location
    hubname: hubname
    subnetbastionid: vnetHub.outputs.subnetbastionid
    loganalyticsid: loganalytics.outputs.loganalyticsid
  }
  dependsOn:[
    vnetHub
  ]
}

module hubafw 'firewall.bicep' = {
  name: 'afwhub'
  params:{
    location: location
    hubname: hubname
    subnetafwid: vnetHub.outputs.subnetafwid
    loganalyticsid: loganalytics.outputs.loganalyticsid
  }
  dependsOn:[
    vnetHub
  ]
}
