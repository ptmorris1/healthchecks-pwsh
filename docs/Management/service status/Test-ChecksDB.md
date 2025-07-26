---
document type: cmdlet
external help file: healthcheckspwsh-Help.xml
HelpUri: ''
Locale: en-US
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: Test-ChecksDB
---

# Test-ChecksDB

## SYNOPSIS

Test the Healthchecks database connection/status endpoint.

## SYNTAX

### __AllParameterSets

```
Test-ChecksDB [-BaseUrl] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Calls the /api/v3/status/ endpoint of a Healthchecks instance to test the database connection.
Returns a PSCustomObject with the result and status message.

## EXAMPLES

### EXAMPLE 1

Test-ChecksDB -BaseUrl "https://checks.example.com"

Tests the Healthchecks instance's database connection and returns the result.

## PARAMETERS

### -BaseUrl

The base URL of the Healthchecks instance.

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

Useful for monitoring or troubleshooting Healthchecks server connectivity.


## RELATED LINKS

{{ Fill in the related links here }}

