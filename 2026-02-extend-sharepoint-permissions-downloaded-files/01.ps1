# Checks the tenant prerequisites for extending SharePoint permissions to downloaded files.
# Run in Windows PowerShell 5.1 with the SharePoint Online Management Shell 16.0.25430.12000 or later,
# and the ExchangeOnlineManagement module for the co-authoring check.

param(
    [Parameter(Mandatory = $true)]
    [string]$AdminUrl   # for example https://contoso-admin.sharepoint.com
)

Connect-SPOService -Url $AdminUrl
Get-SPOTenant | Select-Object EnableAIPIntegration, EnableSensitivityLabelforPDF, ExtendPermissionsToUnprotectedFiles

# Co-authoring for files encrypted with sensitivity labels
Connect-IPPSSession
Get-PolicyConfig | Select-Object EnableLabelCoauth
