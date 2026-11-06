# Compares two "Export to zip" snapshots of Purview policy configuration (the extracted XML files)
# and lists items that were added, removed or changed between them.
# Reads local files only, it doesn't connect to any service.

param(
    [Parameter(Mandatory = $true)] [string]$OldXml,
    [Parameter(Mandatory = $true)] [string]$NewXml,
    # Properties that change on every save and would make every item look modified
    [string[]]$IgnoreProperties = @('WhenChanged', 'WhenChangedUTC', 'LastModifiedTime', 'DistributionStatus')
)

$old = Import-Clixml -Path $OldXml
$new = Import-Clixml -Path $NewXml

function Get-Fingerprint($item) {
    $item | Select-Object -Property * -ExcludeProperty $IgnoreProperties | ConvertTo-Json -Depth 6 -Compress
}

$collections = ($new | Get-Member -MemberType Properties).Name

foreach ($collection in $collections) {
    $before = @{}; foreach ($i in @($old.$collection)) { if ($i.Name) { $before[$i.Name] = Get-Fingerprint $i } }
    $after  = @{}; foreach ($i in @($new.$collection)) { if ($i.Name) { $after[$i.Name]  = Get-Fingerprint $i } }

    foreach ($name in $after.Keys)  { if (-not $before.ContainsKey($name)) { [pscustomobject]@{ Collection = $collection; Name = $name; Change = 'Added' } } }
    foreach ($name in $before.Keys) { if (-not $after.ContainsKey($name))  { [pscustomobject]@{ Collection = $collection; Name = $name; Change = 'Removed' } } }
    foreach ($name in $after.Keys)  { if ($before.ContainsKey($name) -and $before[$name] -ne $after[$name]) { [pscustomobject]@{ Collection = $collection; Name = $name; Change = 'Changed' } } }
}
