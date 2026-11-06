# Creates a Conditional Access policy in report-only mode that blocks Office 365 for users
# with the Elevated insider risk level from Purview Adaptive Protection.
# Requires: Conditional Access Administrator and Microsoft.Graph.Authentication.

param(
    [Parameter(Mandatory = $true)]
    [string[]]$BreakGlassUpn
)

Connect-MgGraph -Scopes "Policy.Read.All", "Policy.ReadWrite.ConditionalAccess", "User.Read.All" -NoWelcome

$excludeIds = foreach ($upn in $BreakGlassUpn) {
    (Invoke-MgGraphRequest GET "v1.0/users/$($upn)?`$select=id").id
}

$body = @{
    displayName = "CA - Block Office 365 for elevated insider risk"
    state       = "enabledForReportingButNotEnforced"
    conditions  = @{
        users = @{
            includeUsers = @("All")
            excludeUsers = @($excludeIds)
            excludeGuestsOrExternalUsers = @{
                guestOrExternalUserTypes = "b2bDirectConnectUser,otherExternalUser,serviceProvider"
                externalTenants          = @{
                    "@odata.type"  = "#microsoft.graph.conditionalAccessAllExternalTenants"
                    membershipKind = "all"
                }
            }
        }
        applications      = @{ includeApplications = @("Office365") }
        clientAppTypes    = @("all")
        insiderRiskLevels = "elevated"
    }
    grantControls = @{ operator = "OR"; builtInControls = @("block") }
} | ConvertTo-Json -Depth 6

Invoke-MgGraphRequest POST "v1.0/identity/conditionalAccess/policies" -Body $body -ContentType "application/json"
Disconnect-MgGraph | Out-Null
