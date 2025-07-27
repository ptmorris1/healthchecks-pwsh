---
document type: cmdlet
external help file: healthcheckspwsh-Help.xml
HelpUri: 'https://ptmorris1.github.io/healthchecks-pwsh/Management/badges/Get-ProjectBadges.html'
Locale: en-US
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: Get-ProjectBadges
---

# Get-ProjectBadges

## SYNOPSIS

List all badge URLs for tags in the Healthchecks project.

## SYNTAX

### __AllParameterSets

```powershell
Get-ProjectBadges [-ApiKey] <string> [-BaseUrl] <string> [<CommonParameters>]
```

## ALIASES

_None_

## DESCRIPTION

Retrieves a map of all tags in the project, with badge URLs for each tag and format (svg, json, shields, etc.) using the API v3.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ProjectBadges -ApiKey $apiKey -BaseUrl "https://checks.example.com"
```

Lists all badge URLs for the project.

## PARAMETERS

### -ApiKey
The Healthchecks API key for authentication.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BaseUrl
The base URL of the Healthchecks instance.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

_None_

## OUTPUTS

### PSCustomObject with Url, StatusCode, StatusMessage, Badges, and Success properties

Returns a PSCustomObject with the following properties:
- Url
- StatusCode
- StatusMessage
- Badges
- Success

## NOTES

Only works for projects you have permission to view. All parameters are required.

## RELATED LINKS

- [Healthchecks API v3 Docs](https://healthchecks.io/docs/api/)
- [Project Repository](https://github.com/ptmorris1/healthchecks-pwsh)