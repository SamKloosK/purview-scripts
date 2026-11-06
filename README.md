# Purview scripts

PowerShell scripts for Microsoft Purview: sensitivity labels, DLP, retention and the rest of the information protection stack. Small, single-purpose scripts that fix one thing or answer one question.

For deploying a full Purview configuration from a JSON file, see [purview-as-code](https://github.com/SamKloosK/purview-as-code).

Every script is provided as is. Read it before you run it and test it in a non-production tenant first.

## Scripts

| Script | What it does |
|---|---|
| [labels/Disable-LabelWatermark.ps1](labels/Disable-LabelWatermark.ps1) | Turns off the watermark on sensitivity labels, working around the "text can not be empty" error you get from Set-Label |

## From the blog

Each folder belongs to one post on [argusit.nl](https://www.argusit.nl/en/blog).

| Date | Post | Scripts |
|---|---|---|
| 2025-10-07 | [Label groups replace parent labels: what changes for sensitivity labels from 1 October 2025](https://www.argusit.nl/en/blog/label-groups-replace-parent-labels) | [1](2025-10-label-groups-replace-parent-labels/) |
| 2025-12-04 | [DLP for Microsoft 365 Copilot after Ignite: blocking labeled content versus blocking sensitive prompts](https://www.argusit.nl/en/blog/dlp-for-microsoft-365-copilot-labels-and-prompts) | [1](2025-12-dlp-for-microsoft-365-copilot-labels-and-prompts/) |
| 2026-01-26 | [Adaptive Protection and the insider risk condition in Conditional Access](https://www.argusit.nl/en/blog/adaptive-protection-insider-risk-in-conditional-access) | [1](2026-01-adaptive-protection-insider-risk-in-conditional-access/) |
| 2026-02-12 | [Extending SharePoint permissions to downloaded files: what the January client update fixes](https://www.argusit.nl/en/blog/extend-sharepoint-permissions-downloaded-files) | [1](2026-02-extend-sharepoint-permissions-downloaded-files/) |
| 2026-04-27 | [Exporting your DLP and label policy configuration as a ZIP: useful, but not configuration as code](https://www.argusit.nl/en/blog/export-purview-policy-configuration-zip) | [1](2026-04-export-purview-policy-configuration-zip/) |
| 2026-08-25 | [App-only authentication for eDiscovery cmdlets is unsupported: what that means for your automations](https://www.argusit.nl/en/blog/ediscovery-app-only-authentication-unsupported) | [1](2026-08-ediscovery-app-only-authentication-unsupported/) |
| 2026-11-10 | [Purview as code: why -WhatIf deployed everything, and what else I fixed before publishing](https://www.argusit.nl/en/blog/purview-as-code-whatif) | [2](2026-11-purview-as-code-whatif/) |
| 2026-11-23 | [Turning off a sensitivity label watermark in PowerShell: the "text can not be empty" error](https://www.argusit.nl/en/blog/turn-off-sensitivity-label-watermark-powershell) | [1](labels/Disable-LabelWatermark.ps1) |

## Prerequisites

- PowerShell 7
- `Install-Module ExchangeOnlineManagement`, then `Connect-IPPSSession`
- A role that can manage the setting you're changing, for example Information Protection Admin for labels

Samantha Kloos-Kilkens, [Argus IT](https://www.argusit.nl)
