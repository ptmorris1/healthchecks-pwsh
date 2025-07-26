---
document type: cmdlet
external help file: healthcheckspwsh-Help.xml
HelpUri: ''
Locale: en-US
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: Remove-Check
---

# Remove-Check

## SYNOPSIS

Remove (delete) a Healthchecks check by UUID.

## SYNTAX

### __AllParameterSets

```
Remove-Check [-ApiKey] <string> [-BaseUrl] <string> [-UUID] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Deletes a check from a Healthchecks instance using the API v3.
The check and its pings will be permanently removed.

## EXAMPLES

### EXAMPLE 1

Remove-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

Deletes the check with the specified UUID.

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

The UUID of the check to delete.

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

Only works for checks you have permission to manage.
Returns success if the check is deleted.


## RELATED LINKS

{{ Fill in the related links here }}

