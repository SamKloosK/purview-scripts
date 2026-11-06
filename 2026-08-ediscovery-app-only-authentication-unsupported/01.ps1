# Connects to Microsoft Graph with app-only authentication (certificate) and lists the
# eDiscovery cases with their status, as a first test of an automation moved off
# Security & Compliance PowerShell.
# Requires an app registration with the eDiscovery.Read.All application permission and
# admin consent, and the app's service principal set up in Purview as described in
# "Set up app-only access for Microsoft Purview eDiscovery".

param(
    [Parameter(Mandatory = $true)] [string]$TenantId,
    [Parameter(Mandatory = $true)] [string]$ClientId,
    [Parameter(Mandatory = $true)] [string]$CertificateThumbprint
)

Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -CertificateThumbprint $CertificateThumbprint -NoWelcome

$cases = (Invoke-MgGraphRequest GET "v1.0/security/cases/ediscoveryCases").value
$cases | ForEach-Object { [pscustomobject]@{ Name = $_.displayName; Status = $_.status; Created = $_.createdDateTime } }

Disconnect-MgGraph | Out-Null
