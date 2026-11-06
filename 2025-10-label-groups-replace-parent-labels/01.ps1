# Lists the parent labels in a tenant on the classic label scheme, with flags for label actions
# and auto-labeling conditions. Advanced settings (the Settings property) need a manual look.
# A parent label with label actions becomes a label group plus an extra sublabel when you migrate
# to the modern label scheme. Different policies or scopes do the same, but don't show up here.

Connect-IPPSSession

$labels    = Get-Label
$parentIds = $labels.ParentId | Where-Object { $_ } | Sort-Object -Unique

$labels | Where-Object { $parentIds -contains $_.Guid.ToString() } |
    Select-Object Name, DisplayName, ContentType,
        @{ Name = 'HasLabelActions'; Expression = { [bool]$_.LabelActions } },
        @{ Name = 'HasConditions';   Expression = { [bool]$_.Conditions } }
