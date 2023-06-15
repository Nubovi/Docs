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
    # built-in reader role: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#reader
    az role assignment create --assignee $app.appId --role "Reader" --scope $g.id
    # built-in cost mangament contributor role: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#cost-management-contributor
    az role assignment create --assignee $app.appId --role "Cost Management Contributor" --scope $g.id
    
}
# retrieve app.tenant, app.appId and app.password in terminal
Write-Host $app.tenant
Write-Host $app.appId
Write-Host $app.password