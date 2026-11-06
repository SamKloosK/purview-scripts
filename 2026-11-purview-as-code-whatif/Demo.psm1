# Demo module for the -WhatIf scope issue: a function that supports ShouldProcess.
function Set-Thing {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    if ($PSCmdlet.ShouldProcess("tenant", "Change setting")) { "CHANGED: this ran for real" }
}
