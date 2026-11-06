# Run .\Deploy.ps1 -WhatIf
# Without the fix the module function runs for real, because $WhatIfPreference doesn't flow
# from a script into a script module. Switch to the second call to see the fix.
[CmdletBinding(SupportsShouldProcess)]
param()
Import-Module (Join-Path $PSScriptRoot "Demo.psm1") -Force

Set-Thing                              # runs for real, even with -WhatIf
# Set-Thing -WhatIf:$WhatIfPreference  # the fix: pass -WhatIf explicitly
