---
document type: cmdlet
external help file: healthcheckspwsh-Help.xml
HelpUri: ''
Locale: en-US
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: Get-Check
---

# Get-Check

## SYNOPSIS

Get details about one or more Healthchecks checks by UUID, slug, or tag.

## SYNTAX

### __AllParameterSets

```
Get-Check [-ApiKey] <string> [-BaseUrl] <string> [[-Slug] <string>] [[-Tag] <string[]>]
 [[-UUID] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Retrieves information about checks from a Healthchecks instance using the API v3.
You can query by UUID (for a single check), by slug, or by one or more tags.
If UUID is specified, Slug and Tag must not be used.

## EXAMPLES

### EXAMPLE 1

Get-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

Retrieves the check with the specified UUID.

### EXAMPLE 2

Get-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -Tag "prod","db"

Retrieves all checks with the tags "prod" and "db".

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

The base URL of the Healthchecks instance (e.g., https://checks.example.com).

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

### -Slug

(Optional) The slug of the check to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

(Optional) One or more tags to filter checks by.
Accepts an array of strings.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UUID

(Optional) The UUID of the check to retrieve.
If specified, Slug and Tag must not be used.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
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

If UUID is specified, do not specify Slug or Tag.
All parameters except ApiKey and BaseUrl are optional.


## RELATED LINKS

{{ Fill in the related links here }}

