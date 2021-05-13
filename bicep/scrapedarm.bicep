param sites_lapp_ais_demo_nonprod_name string = 'lapp-ais-demo-nonprod'
param serverfarms_lappaisdemononprod_name string = 'lappaisdemononprod'
param components_lappaisdemononprod_name string = 'lappaisdemononprod'
param storageAccounts_lappaisdemononprod_name string = 'lappaisdemononprod'
param smartdetectoralertrules_failure_anomalies_lappaisdemononprod_name string = 'failure anomalies - lappaisdemononprod'
param actiongroups_application_insights_smart_detection_externalid string = '/subscriptions/ca9ae6cf-2ab2-48d0-981d-c1030fd74a64/resourceGroups/rg-uks-ais-demo-apim-nonprod/providers/microsoft.insights/actiongroups/application insights smart detection'

resource components_lappaisdemononprod_name_resource 'microsoft.insights/components@2020-02-02-preview' = {
  name: components_lappaisdemononprod_name
  location: 'uksouth'
  tags: {
    Application: 'Azure Integration Services Demo'
    Environment: 'nonprod'
    Keep: 'Yes'
  }
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

resource storageAccounts_lappaisdemononprod_name_resource 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccounts_lappaisdemononprod_name
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

resource serverfarms_lappaisdemononprod_name_resource 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: serverfarms_lappaisdemononprod_name
  location: 'UK South'
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

resource smartdetectoralertrules_failure_anomalies_lappaisdemononprod_name_resource 'microsoft.alertsmanagement/smartdetectoralertrules@2021-04-01' = {
  name: smartdetectoralertrules_failure_anomalies_lappaisdemononprod_name
  location: 'global'
  properties: {
    description: 'Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls.'
    state: 'Enabled'
    severity: 'Sev3'
    frequency: 'PT1M'
    detector: {
      id: 'FailureAnomaliesDetector'
    }
    scope: [
      components_lappaisdemononprod_name_resource.id
    ]
    actionGroups: {
      groupIds: [
        actiongroups_application_insights_smart_detection_externalid
      ]
    }
  }
}

resource components_lappaisdemononprod_name_degradationindependencyduration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/degradationindependencyduration'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'degradationindependencyduration'
      DisplayName: 'Degradation in dependency duration'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_degradationinserverresponsetime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/degradationinserverresponsetime'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'degradationinserverresponsetime'
      DisplayName: 'Degradation in server response time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_digestMailConfiguration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/digestMailConfiguration'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'digestMailConfiguration'
      DisplayName: 'Digest Mail Configuration'
      Description: 'This rule describes the digest mail preferences'
      HelpUrl: 'www.homail.com'
      IsHidden: true
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_extension_billingdatavolumedailyspikeextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/extension_billingdatavolumedailyspikeextension'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'extension_billingdatavolumedailyspikeextension'
      DisplayName: 'Abnormal rise in daily data volume (preview)'
      Description: 'This detection rule automatically analyzes the billing data generated by your application, and can warn you about an unusual increase in your application\'s billing costs'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/tree/master/SmartDetection/billing-data-volume-daily-spike.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_extension_canaryextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/extension_canaryextension'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'extension_canaryextension'
      DisplayName: 'Canary extension'
      Description: 'Canary extension'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/'
      IsHidden: true
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_extension_exceptionchangeextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/extension_exceptionchangeextension'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'extension_exceptionchangeextension'
      DisplayName: 'Abnormal rise in exception volume (preview)'
      Description: 'This detection rule automatically analyzes the exceptions thrown in your application, and can warn you about unusual patterns in your exception telemetry.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/abnormal-rise-in-exception-volume.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_extension_memoryleakextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/extension_memoryleakextension'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'extension_memoryleakextension'
      DisplayName: 'Potential memory leak detected (preview)'
      Description: 'This detection rule automatically analyzes the memory consumption of each process in your application, and can warn you about potential memory leaks or increased memory consumption.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/tree/master/SmartDetection/memory-leak.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_extension_securityextensionspackage 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/extension_securityextensionspackage'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'extension_securityextensionspackage'
      DisplayName: 'Potential security issue detected (preview)'
      Description: 'This detection rule automatically analyzes the telemetry generated by your application and detects potential security issues.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/application-security-detection-pack.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_extension_traceseveritydetector 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/extension_traceseveritydetector'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'extension_traceseveritydetector'
      DisplayName: 'Degradation in trace severity ratio (preview)'
      Description: 'This detection rule automatically analyzes the trace logs emitted from your application, and can warn you about unusual patterns in the severity of your trace telemetry.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/degradation-in-trace-severity-ratio.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_longdependencyduration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/longdependencyduration'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'longdependencyduration'
      DisplayName: 'Long dependency duration'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_migrationToAlertRulesCompleted 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/migrationToAlertRulesCompleted'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'migrationToAlertRulesCompleted'
      DisplayName: 'Migration To Alert Rules Completed'
      Description: 'A configuration that controls the migration state of Smart Detection to Smart Alerts'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: true
      IsEnabledByDefault: false
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: false
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_slowpageloadtime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/slowpageloadtime'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'slowpageloadtime'
      DisplayName: 'Slow page load time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_lappaisdemononprod_name_slowserverresponsetime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${components_lappaisdemononprod_name_resource.name}/slowserverresponsetime'
  location: 'uksouth'
  properties: {
    RuleDefinitions: {
      Name: 'slowserverresponsetime'
      DisplayName: 'Slow server response time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource storageAccounts_lappaisdemononprod_name_default 'Microsoft.Storage/storageAccounts/blobServices@2021-02-01' = {
  name: '${storageAccounts_lappaisdemononprod_name_resource.name}/default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_lappaisdemononprod_name_default 'Microsoft.Storage/storageAccounts/fileServices@2021-02-01' = {
  name: '${storageAccounts_lappaisdemononprod_name_resource.name}/default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_lappaisdemononprod_name_default 'Microsoft.Storage/storageAccounts/queueServices@2021-02-01' = {
  name: '${storageAccounts_lappaisdemononprod_name_resource.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default 'Microsoft.Storage/storageAccounts/tableServices@2021-02-01' = {
  name: '${storageAccounts_lappaisdemononprod_name_resource.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_lapp_ais_demo_nonprod_name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: sites_lapp_ais_demo_nonprod_name
  location: 'UK South'
  kind: 'functionapp,workflowapp'
  identity: {
    principalId: '21f92bcb-8eac-454b-910a-340cf339dc0f'
    tenantId: '72f988bf-86f1-41af-91ab-2d7cd011db47'
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_lapp_ais_demo_nonprod_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_lapp_ais_demo_nonprod_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_lappaisdemononprod_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {}
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    redundancyMode: 'None'
  }
}

resource sites_lapp_ais_demo_nonprod_name_web 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${sites_lapp_ais_demo_nonprod_name_resource.name}/web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$lapp-ais-demo-nonprod'
    azureStorageAccounts: {}
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    localMySqlEnabled: false
    managedServiceIdentityId: 8374
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    reservedInstanceCount: 0
  }
}

resource sites_lapp_ais_demo_nonprod_name_sites_lapp_ais_demo_nonprod_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2018-11-01' = {
  name: '${sites_lapp_ais_demo_nonprod_name_resource.name}/${sites_lapp_ais_demo_nonprod_name}.azurewebsites.net'
  properties: {
    siteName: 'lapp-ais-demo-nonprod'
    hostNameType: 'Verified'
  }
}

resource storageAccounts_lappaisdemononprod_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${storageAccounts_lappaisdemononprod_name_default.name}/azure-webjobs-hosts'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${storageAccounts_lappaisdemononprod_name_default.name}/azure-webjobs-secrets'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_lapp_ais_demo_nonprod5e03ef 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_fileServices_storageAccounts_lappaisdemononprod_name_default.name}/lapp-ais-demo-nonprod5e03ef'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898jobtriggers00 'Microsoft.Storage/storageAccounts/queueServices/queues@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_queueServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898jobtriggers00'
  properties: {
    metadata: {}
  }
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf89882f6b8359eb800bflows 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf89882f6b8359eb800bflows'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898flowaccesskeys 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898flowaccesskeys'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898flowruntimecontext 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898flowruntimecontext'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898flows 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898flows'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898flowsubscriptions 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898flowsubscriptions'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898flowsubscriptionsummary 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898flowsubscriptionsummary'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}

resource storageAccounts_lappaisdemononprod_name_default_flow127c136301cf898jobdefinitions 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${Microsoft_Storage_storageAccounts_tableServices_storageAccounts_lappaisdemononprod_name_default.name}/flow127c136301cf898jobdefinitions'
  dependsOn: [
    storageAccounts_lappaisdemononprod_name_resource
  ]
}
