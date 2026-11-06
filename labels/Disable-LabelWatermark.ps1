# Disable-LabelWatermark.ps1
# Turns off the watermark on one or more sensitivity labels.
#
# Why a script for one setting: Set-Label -ApplyWaterMarkingEnabled $false on its own fails with
# "TextEmptyException: The text can not be empty". In my tests it only worked when the watermark
# text was sent along. This script reads the current text from the label and passes it back.
#
#   Connect-IPPSSession
#   .\Disable-LabelWatermark.ps1 -LabelName "Confidential-AllEmployees", "HighlyConfidential-AllEmployees"
#   .\Disable-LabelWatermark.ps1 -All -WhatIf
#
# Office apps can take up to 24 hours to pick up the change. Documents that already carry a
# watermark keep it until the label is applied or changed again.

[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "ByName")]
param(
    [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
    [string[]]$LabelName,

    [Parameter(Mandatory = $true, ParameterSetName = "All")]
    [switch]$All
)

if (-not (Get-Command Get-Label -ErrorAction SilentlyContinue)) {
    throw "Not connected to Security & Compliance PowerShell. Run Connect-IPPSSession first."
}

function Get-WatermarkAction {
    param($Label)
    foreach ($action in $Label.LabelActions) {
        $parsed = $action | ConvertFrom-Json
        if ($parsed.Type -eq "applywatermarking") { return $parsed }
    }
}

function Get-ActionSetting {
    param($Action, [string]$Key)
    ($Action.Settings | Where-Object { $_.Key -eq $Key }).Value
}

$labels = if ($All) { Get-Label } else { $LabelName | ForEach-Object { Get-Label -Identity $_ } }

foreach ($label in $labels) {
    $watermark = Get-WatermarkAction -Label $label

    if (-not $watermark) {
        Write-Host "SKIP   $($label.Name): no watermark configured" -ForegroundColor Gray
        continue
    }
    if ((Get-ActionSetting -Action $watermark -Key "disabled") -eq "true") {
        Write-Host "SKIP   $($label.Name): watermark already off" -ForegroundColor Gray
        continue
    }

    $text = Get-ActionSetting -Action $watermark -Key "text"

    if ($PSCmdlet.ShouldProcess($label.Name, "Turn off watermark '$text'")) {
        try {
            Set-Label -Identity $label.Name -ApplyWaterMarkingEnabled $false -ApplyWaterMarkingText $text -ErrorAction Stop
            Write-Host "OK     $($label.Name): watermark off" -ForegroundColor Green
        }
        catch {
            Write-Host "ERROR  $($label.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
