# Creates a DLP policy for the Microsoft 365 Copilot location that excludes content with one
# sensitivity label from Copilot processing. Starts in TestWithNotifications.

Connect-IPPSSession

# GUID of the label to exclude from Copilot processing
Get-Label | Format-Table Name, DisplayName, Guid
$labelGuid = "<label GUID>"

# Microsoft 365 Copilot location, scoped to all users
$loc = '[{"Workload":"Applications","Location":"470f2276-e011-4e9d-a6ec-20768be3a4b0","Inclusions":[{"Type":"Tenant","Identity":"All"}]}]'

New-DlpCompliancePolicy -Name "Copilot - exclude labeled content" -Locations $loc -EnforcementPlanes @("CopilotExperiences") -Mode TestWithNotifications

$advRule = @{
    Version   = "1.0"
    Condition = @{
        Operator      = "And"
        SubConditions = @(
            @{
                ConditionName = "ContentContainsSensitiveInformation"
                Value = @(
                    @{
                        groups = @(
                            @{
                                Operator = "Or"
                                name     = "Default"
                                labels   = @( @{ name = $labelGuid; type = "Sensitivity" } )
                            }
                        )
                    }
                )
            }
        )
    }
} | ConvertTo-Json -Depth 100

New-DlpComplianceRule -Name "Copilot - exclude labeled content" -Policy "Copilot - exclude labeled content" -AdvancedRule $advRule -RestrictAccess @(@{ setting = "ExcludeContentProcessing"; value = "Block" })
