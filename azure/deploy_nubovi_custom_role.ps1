# DEPENDENCY: Run by Azure administrator
# DEPENDENCY: Install Azure CLI
# DEPENDENCY: Execute script using PowerShell 7 or up or using Azure Cloud Shell
function Register-NuboviCustomRole {
    param (
        [Parameter(Mandatory=$true)]
        [string]$tenantId
    )  
    # Log into tenant
    az login --tenant $tenantId
    # Get all subscriptions in tenant
    $subscriptions = (az account list --query "[?tenantId == '$tenantId'].id" | ConvertFrom-Json)
    # Prepare Nubovi custom role definition
    $roleName = "Nubovi Reader Custom"
    # Populate assignable scopes
    $assignableScopes = @()
    Foreach ($subscriptionId in $subscriptions) {
        $assignableScopes += "/subscriptions/$subscriptionId"
    }
    # Populate role definition
    $roleDefinition = @{
        Name = $roleName
        IsCustom = $true
        Description = "Can read billing data and resource usage logs."
        Actions = @(
            # Review custom role and comment out any action that should not be granted to Nubovi
            "Microsoft.Compute/*/read",
            "Microsoft.Cdn/*/Microsoft.Insights/diagnosticSettings/read",
            "Microsoft.Cdn/*/Microsoft.Insights/logDefinitions/read",
            "Microsoft.Cdn/*/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.ClassicNetwork/*/diagnosticSettings/read",
            "Microsoft.ClassicNetwork/operations/read",
            "Microsoft.ClassicNetwork/quotas/read",
            "Microsoft.HybridConnectivity/endpoints/read",
            "Microsoft.Network/*/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.ClassicStorage/*/read",
            "Microsoft.DataShare/accounts/read",
            "Microsoft.DataShare/accounts/providers/Microsoft.Insights/*/read",
            "Microsoft.ImportExport/jobs/read",
            "Microsoft.NetApp/locations/quotaLimits/read",
            "Microsoft.NetApp/netAppAccounts/capacityPools/providers/Microsoft.Insights/*/read",
            "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/providers/Microsoft.Insights/*/read",
            "Microsoft.Storage/locations/usages/read",
            "Microsoft.Storage/skus/read",
            "Microsoft.Storage/storageAccounts/read",
            "Microsoft.Storage/storageAccounts/blobServices/providers/Microsoft.Insights/*/read",
            "Microsoft.Storage/storageAccounts/fileServices/providers/Microsoft.Insights/*/read",
            "Microsoft.Storage/storageAccounts/queueServices/providers/Microsoft.Insights/*/read",
            "Microsoft.Storage/storageAccounts/tableServices/providers/Microsoft.Insights/*/read",
            "microsoft.storagesync/storageSyncServices/providers/Microsoft.Insights/*/read",
            "Microsoft.StorSimple/*/metrics/read",
            "Microsoft.StorSimple/*/metricsDefinitions/read",
            "Microsoft.AppPlatform/*/metricDefinitions/read",
            "Microsoft.AppPlatform/*/monitoringSettings/read",
            "Microsoft.AppPlatform/*/diagnosticSettings/read",
            "Microsoft.AppPlatform/*/logDefinitions/read",
            "Microsoft.Maps/*/Microsoft.Insights/diagnosticSettings/read",
            "Microsoft.Maps/*/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.Media/*/providers/Microsoft.Insights/diagnosticSettings/read",
            "Microsoft.Media/*/providers/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.Media/*/providers/Microsoft.Insights/logDefinitions/read",
            "Microsoft.Search/*/logDefinitions/read",
            "Microsoft.Search/*/metricDefinitions/read",
            "Microsoft.SignalRService/*/Microsoft.Insights/diagnosticSettings/read",
            "Microsoft.SignalRService/*/Microsoft.Insights/logDefinitions/read",
            "Microsoft.SignalRService/*/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.SignalRService/skus/read",
            "microsoft.web/billingmeters/read",
            "Microsoft.Web/*/Microsoft.Insights/metricDefinitions/Read",
            "Microsoft.Web/*/Microsoft.Insights/diagnosticSettings/Read",
            "Microsoft.Web/*/Microsoft.Insights/logDefinitions/Read",
            "microsoft.web/hostingenvironments/*/read",
            "microsoft.web/resourcehealthmetadata/read",
            "Microsoft.Web/recommendations/Read",
            "Microsoft.Web/serverfarms/Read",
            "microsoft.web/serverfarms/*/read",
            "Microsoft.Web/sites/Read",
            "microsoft.web/sites/*/read",
            "Microsoft.ContainerInstance/containerGroups/read",
            "Microsoft.ContainerInstance/containerGroups/containers/logs/read",
            "Microsoft.ContainerInstance/*/Microsoft.Insights/diagnosticSettings/read",
            "Microsoft.ContainerInstance/*/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.ContainerInstance/locations/*/read",
            "Microsoft.ContainerRegistry/*/read",
            "Microsoft.ContainerRegistry/*/Microsoft.Insights/diagnosticSettings/read",
            "Microsoft.ContainerRegistry/*/Microsoft.Insights/logDefinitions/read",
            "Microsoft.ContainerRegistry/*/Microsoft.Insights/metricDefinitions/read",
            "Microsoft.ContainerService/*/read",
            "Microsoft.Cache/*/read",
            "Microsoft.DataFactory/*/read",
            "Microsoft.DataMigration/*/read",
            "Microsoft.DBforMariaDB/*/read",
            "Microsoft.DBforMySQL",
            "Microsoft.DBforPostgreSQL/*/read",
            "Microsoft.DocumentDB/*/read",
            "Microsoft.Sql/*/read",
            "Microsoft.SqlVirtualMachine/*/read",
            "Microsoft.AnalysisServices/*/read",
            "Microsoft.Databricks/*/read",
            "Microsoft.DataLakeAnalytics/*/read",
            "Microsoft.DataLakeStore/*/read",
            "Microsoft.EventHub/*/read",
            "Microsoft.HDInsight/*/read",
            "Microsoft.Kusto/*/read",
            "Microsoft.PowerBIDedicated/*/read",
            "Microsoft.StreamAnalytics/*/read",
            "Microsoft.Synapse//*/read",
            "Microsoft.BotService/*/read",
            "Microsoft.CognitiveServices/*/read",
            "Microsoft.MachineLearning/*/read",
            "Microsoft.MachineLearningServices/*/read",
            "Microsoft.Devices/*/read",
            "Microsoft.DeviceUpdate/*/read",
            "Microsoft.IoTCentral/*/read",
            "Microsoft.IoTSecurity/*/read",
            "Microsoft.NotificationHubs/*/read",
            "Microsoft.TimeSeriesInsights/*/read",
            "Microsoft.MixedReality/*/read",
            "Microsoft.ApiManagement/*/read",
            "Microsoft.AppConfiguration/*/read",
            "Microsoft.AzureStack/*/read",
            "Microsoft.DataBoxEdge/*/read",
            "Microsoft.EventGrid/*/read",
            "Microsoft.Logic/*/read",
            "Microsoft.Relay/*/read",
            "Microsoft.ServiceBus/*/read",
            "Microsoft.ADHybridHealthService/*/read",
            "Microsoft.KeyVault/*/read",
            "Microsoft.Security/*/read",
            "Microsoft.SecurityGraph/*/read",
            "Microsoft.SecurityInsights/*/read",
            "Microsoft.DevTestLab/*/read",
            "Microsoft.LabServices/*/read",
            "Microsoft.Migrate/*/read",
            "Microsoft.OffAzure/*/read",
            "Microsoft.AlertsManagement/*/read",
            "Microsoft.Insights/*/read",
            "Microsoft.OperationalInsights/*/read",
            "Microsoft.OperationsManagement/*/read",
            "Microsoft.WorkloadMonitor/*/read",
            "Microsoft.Advisor/*/read",
            "Microsoft.Authorization/*/read",
            "Microsoft.Automation/*/read",
            "Microsoft.Batch/*/read",
            "Microsoft.Billing/*/read",
            "Microsoft.Blueprint/*/read",
            "Microsoft.Capacity/*/read",
            "Microsoft.Capacity/checkoffers/action",
            "Microsoft.Capacity/checkscopes/action",
            "Microsoft.Capacity/validatereservationorder/action",
            "Microsoft.Capacity/listSkus/action",
            "Microsoft.Capacity/reservationorders/calculaterefund/action",
            "Microsoft.Commerce/*/read",
            "Microsoft.Consumption/*/read",
            "Microsoft.CostManagement/query/action",
            "Microsoft.CostManagement/*/read",
            "Microsoft.CostManagement/forecast/action",
            "Microsoft.CostManagement/externalBillingAccounts/query/action",
            "Microsoft.CostManagement/externalBillingAccounts/forecast/action",
            "Microsoft.DataProtection/*/read",
            "Microsoft.Features/*/read",
            "Microsoft.GuestConfiguration//*/read",
            "Microsoft.HybridCompute/*/read",
            "Microsoft.Kubernetes/*/read",
            "Microsoft.Management/*/read",
            "Microsoft.Management/getEntities/action",
            "Microsoft.Management/checkNameAvailability/action",
            "Microsoft.PolicyInsights/*/read",
            "Microsoft.Portal/*/read",
            "Microsoft.RecoveryServices/*/read",
            "Microsoft.Resources/*/read",
            "Microsoft.Scheduler/*/read",
            "Microsoft.Solutions/*/read",
            "Microsoft.Subscription/*/read",
            "Microsoft.Intune/*/read",
            "Microsoft.DesktopVirtualization/*/read",
            "Microsoft.DigitalTwins/*/read",
            "Microsoft.ServicesHub/*/read"
        )
        NotActions = @() | ConvertTo-Json
        AssignableScopes = $assignableScopes
    }
    # Convert the role definition to a JSON string
    $roleDefinitionJson= $roleDefinition | ConvertTo-Json
    # Write the role definition to a file
    $roleDefinitionJson | Out-File nubovi-role-custom.json  
    # Register the custom role using the Azure CLI command
    az role definition create --role-definition @nubovi-role-custom.json
    # Create new service principal
    $app = (az ad sp create-for-rbac -n $roleName | ConvertFrom-Json) 
    # Assign built-in Reader role to service principal for each subscription
    Foreach ($subscriptionId in $subscriptions) {
        az role assignment create --assignee $app.appId --role $roleName --scope "/subscriptions/$subscriptionId"
    }

    return $app 
}

$app = Register-NuboviCustomRole -tenantId "<TENANT-ID>"

# output app details in terminal
Write-Host $app.tenant
Write-Host $app.appId
Write-Host $app.password