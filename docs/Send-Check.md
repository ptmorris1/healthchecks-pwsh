---
document type: cmdlet
external help file: healthcheckspwsh-Help.xml
HelpUri: ''
Locale: en-US
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: Ping
hide:
  - navigation
---

# Send-Check

## SYNOPSIS

Send a ping to a Healthchecks check by UUID or PingKey/Slug.

## SYNTAX

### __AllParameterSets

```powershell
Send-Check [[-UUID] <string>] [[-PingKey] <string>] [[-Slug] <string>] [-BaseUrl] <string> [[-RunID] <string>] [[-ExitStatus] <int>] [-Start] [-Success] [-Failure] [-Log] [-Create] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

_None_

## DESCRIPTION

Sends a ping to a Healthchecks check using the API v3. Supports both UUID and PingKey/Slug methods, as well as run IDs, status switches, and log/exit status. Can also create a check if it does not exist (with -Create).

## EXAMPLES

### EXAMPLE 1

```powershell
Send-Check -UUID "f618072a-7bde-4eee-af63-71a77c5723bc" -BaseUrl "https://checks.example.com" -Start
```

Sends a "start" ping to the check with the specified UUID.

### EXAMPLE 2

```powershell
Send-Check -PingKey "abc123" -Slug "my-check" -BaseUrl "https://checks.example.com" -Create
```

Sends a ping to the check with the specified PingKey and Slug, creating it if it does not exist.

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
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Create
(Optional) Switch. If specified, create the check if it does not exist (PingKey/Slug only).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExitStatus
(Optional) The exit status code to send with the ping.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Failure
(Optional) Switch. Mark this ping as a "failure" event.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Log
(Optional) Switch. Mark this ping as a "log" event.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PingKey
(Optional) The ping key for the check (used with Slug).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RunID
(Optional) The run ID to associate with the ping.

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

### -Slug
(Optional) The slug for the check (used with PingKey).

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

### -Start
(Optional) Switch. Mark this ping as a "start" event.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Success
(Optional) Switch. Mark this ping as a "success" event.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UUID
(Optional) The UUID of the check to ping.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

### PSCustomObject with Url, StatusCode, StatusMessage, PingBodyLimit, and Success properties

Returns a PSCustomObject with the following properties:
- Url
- StatusCode
- StatusMessage
- PingBodyLimit
- Success

## NOTES

You must specify either UUID or both PingKey and Slug. The -Create switch cannot be used with UUID.

## RELATED LINKS

- [Healthchecks API v3 Docs](https://healthchecks.io/docs/api/)
- [Project Repository](https://github.com/ptmorris1/healthchecks-pwsh)

