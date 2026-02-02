param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("dev", "prod")]
    [string]$Env
)

# Haal subscription + tenant uit Azure CLI context (na az login)
$subId = az account show --query id -o tsv
$tenant = az account show --query tenantId -o tsv

# Zet alleen voor deze PowerShell sessie (niet permanent!)
$env:ARM_SUBSCRIPTION_ID = $subId
$env:ARM_TENANT_ID = $tenant

Write-Host "Terraform context set for session:"
Write-Host "  ARM_SUBSCRIPTION_ID = $env:ARM_SUBSCRIPTION_ID"
Write-Host "  ARM_TENANT_ID       = $env:ARM_TENANT_ID"
Write-Host "  Env                 = $Env"
