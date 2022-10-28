# DEPENDENCY: Run by Azure administrator
# DEPENDENCY: Install Azure CLI
# DEPENDENCY: Execute script using PowerShell 7 or up or using Azure Cloud Shell

# log into tenant
$tenantId="<TENANT-ID>"
az login --tenant $tenantId
# create new service principal
$app=(az ad sp create-for-rbac -n "Nubovi Reader" | ConvertFrom-Json)
# get all subscriptions in tenant
$subscriptions=(az account list --query "[?tenantId == '$tenant'].id" | ConvertFrom-Json) 
# for each subscription, assign built-in Reader role to service principal
Foreach ($s in $subscriptions) 
{
    az role assignment create --assignee $app.appId --role Reader --scope "/subscriptions/$s"
}
# retrieve app.tenant, app.appId and app.password in terminal
Write-Host $app.tenant
Write-Host $app.appId
Write-Host $app.password