---
document type: cmdlet
external help file: healthcheckspwsh-Help.xml
HelpUri: ''
Locale: en-US
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: Get-CheckPings
---

# Get-CheckPings

## SYNOPSIS

List pings for a specific Healthchecks check by UUID.

## SYNTAX

### __AllParameterSets

```
Get-CheckPings [-ApiKey] <string> [-BaseUrl] <string> [-UUID] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Retrieves a list of pings for a check from a Healthchecks instance using the API v3.
Returns all pings for the specified check.

## EXAMPLES

### EXAMPLE 1

Get-CheckPings -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

Lists all pings for the specified check.

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

### -UUID

The UUID of the check to list pings for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject with Url

{{ Fill in the Description }}

## NOTES

Only works for checks you have permission to view.
All parameters are required.


## RELATED LINKS

{{ Fill in the related links here }}

