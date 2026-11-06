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

## Prerequisites

- PowerShell 7
- `Install-Module ExchangeOnlineManagement`, then `Connect-IPPSSession`
- A role that can manage the setting you're changing, for example Information Protection Admin for labels

Samantha Kloos-Kilkens, [Argus IT](https://www.argusit.nl)
