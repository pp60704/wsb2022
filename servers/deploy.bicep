param location string = resourceGroup().location
param vnetname string = 'adsrv'
@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string


module vnetsrv 'vnetsrv.bicep' = {
  name: 'vnetsrv'
  params:{
    location: location
    vnetname: vnetname
  }
}
module winsrv1 'winsrv.bicep' = {
  name: 'winsrv'
  params:{
    location: location
    hostname: 'azwindc01'
    adminUsername: adminUsername
    adminPassword: adminPassword
    subnetid: vnetsrv.outputs.subnetid
  }
  dependsOn:[
    vnetsrv
  ]
}
module winsrv2 'winsrv.bicep' = {
  name: 'winsrv2'
  params:{
    location: location
    hostname: 'azwindc02'
    adminUsername: adminUsername
    adminPassword: adminPassword
    subnetid: vnetsrv.outputs.subnetid
  }
  dependsOn:[
    vnetsrv
  ]
}




