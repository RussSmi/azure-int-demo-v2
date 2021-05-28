param env string
param connections_azureblob_name string = 'azureblob'
param resource_group string
param location string = resourceGroup().location
param sb_conn_str string
param storage_account_name string
param storage_resource_group_name string
param resourceTags object = {
  Application: 'Azure Integration Services Demo'
  Environment: 'nonprod'
  Keep: 'Yes'
}

resource appIns 'microsoft.insights/components@2020-02-02-preview' = {
  name: 'app-ins-lappst-${env}'
  location: location
  tags: resourceTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    SamplingPercentage: 100
    DisableIpMasking: false
    IngestionMode: 'ApplicationInsights'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource strg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'laaisdemostrg${env}'
  location: 'uksouth'
  tags: {
    Application: 'Azure Integration Services Demo'
    Environment: 'nonprod'
    Keep: 'Yes'
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    isHnsEnabled: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource plan 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: 'lappst-plan-ais-demo-${env}'
  location: location
  tags: {
    Application: 'Azure Integration Services Demo'
    Environment: 'nonprod'
    Keep: 'Yes'
  }
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource lappst 'Microsoft.Web/sites@2020-12-01' = {
  name: 'lapp-ais-demo-nonprod'  // must be globally unique
  location: 'uksouth' 
  kind: 'functionapp,workflowapp'
  identity:{
    type:'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: plan.id
  }
}

resource blobstg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storage_account_name
  scope: resourceGroup(storage_resource_group_name)
}


resource appconfig 'Microsoft.Web/sites/config@2018-11-01' = {
  name: 'lapp-ais-demo-nonprod/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appIns.properties.InstrumentationKey
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${strg.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(strg.id, strg.apiVersion).keys[0].value}'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${strg.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(strg.id, strg.apiVersion).keys[0].value}'
    FUNCTIONS_EXTENSION_VERSION: '~3'
    FUNCTIONS_V2_COMPATIBILITY_MODE: 'true'
    FUNCTIONS_WORKER_RUNTIME: 'node'
    WEBSITE_CONTENTSHARE: 'lapp-ais-demo-${env}5e03ef'
    WEBSITE_NODE_DEFAULT_VERSION: '~12'
    WORKFLOWS_LOCATION_NAME: location
    WORKFLOWS_RESOURCE_GROUP_NAME: resource_group
    'Workflows.WebhookRedirectHostUri': ''
    WEBSITE_ENABLE_SYNC_UPDATE_SITE: 'true'
    WEBSITE_RUN_FROM_PACKAGE: '1'
    'serviceBus-connectionString': sb_conn_str
    'storage-url': 'https://str101aisdemononprod.blob.core.windows.net/subscriber'
    'AzureBlob-connectionString' : 'DefaultEndpointsProtocol=https;AccountName=${blobstg.name};AccountKey=${listKeys(blobstg.id, blobstg .apiVersion).keys[1].value}'
  }
}

resource connections_azureblob_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_name
  location: 'uksouth'
  kind: 'V2'
  properties: {
    displayName: 'bicepblobconnection'
    customParameterValues: {}
    api: {
      id: '/subscriptions/ca9ae6cf-2ab2-48d0-981d-c1030fd74a64/providers/Microsoft.Web/locations/uksouth/managedApis/${connections_azureblob_name}'
    }
  }
}
