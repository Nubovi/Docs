# DEPENDENCY: Run by Azure administrator
# DEPENDENCY: Install Azure CLI
# DEPENDENCY: Execute script using PowerShell 7 or up or using Azure Cloud Shell

# log into tenant
$tenantId = "<TENANT-ID>"
az login --tenant $tenantId
# create new service principal
$app=(az ad sp create-for-rbac -n "Nubovi Reader" | ConvertFrom-Json)
# get all management groups
$groups=(az account management-group list --no-register | ConvertFrom-Json)
# for each management group, assign built-in Reader role to service principal
Foreach ($g in $groups) 
{
    az role assignment create --assignee $app.appId --role Reader --scope $g.id
}
# Assign Reservations Reader role to the service principal at the tenant level
az role assignment create --assignee $app.appId --role "Reservations Reader" --scope "/providers/Microsoft.Capacity"
# retrieve app.tenant, app.appId and app.password in terminal
Write-Host $app.tenant
Write-Host $app.appId
Write-Host $app.password