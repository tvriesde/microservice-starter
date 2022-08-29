param env string
param sku string

@allowed([
  'node'
  'dotnet'
  'java'
])
param runtime string = 'node'
param location string = resourceGroup().location
param component string
param product string
param ApiServiceRG string

var apiServiceName = 'apiservice${uniqueString(resourceGroup().id)}'
var env_var = env
var sku_var = sku
var appName = '${product}-${component}-${env}-${location}'
var servicePlanName = 'plan-${appName}'
var storageAccountName = toLower('${product}${uniqueString(resourceGroup().id)}')
var siteName_var = 'site-${appName}'
var applicationInsightsName = 'insights-${appName}'
var apiName = 'api-${appName}'
var functionWorkerRuntime = runtime

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  tags: {
    env: env_var
  }
  location: location
  kind: 'StorageV2'
  sku: {
    name: sku_var
  }
}

resource servicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: servicePlanName
  location: location
  properties: {
  }
  sku: {
    name: 'Y1'
    tier: 'Dynamics'
  }
}

resource site 'Microsoft.Web/sites@2021-03-01' = {
  name: siteName_var
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: servicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~16'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, '2021-08-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, '2021-08-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(appName)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionWorkerRuntime
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
      ]
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
  dependsOn: [
    applicationInsights

  ]
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  kind: 'web'
  location: location
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}



module ApiServiceAPI 'apimanagementapi.bicep' ={
  name: 'Api'
  scope: resourceGroup(ApiServiceRG)
  params:{
    apiName: apiName
    ApiService: ApiServiceName
    ApiServiceRG: ApiServiceRG
  }  
}
