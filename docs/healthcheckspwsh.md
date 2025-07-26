---
document type: module
Help Version: 1.0.0.0
HelpInfoUri: 
Locale: en-US
Module Guid: 7da498f6-4c96-4146-8730-febfc16920a4
Module Name: healthcheckspwsh
ms.date: 07/26/2025
PlatyPS schema version: 2024-05-01
title: 'All Functions'
hide:
  - navigation
---

# healthcheckspwsh Module

## Description

Powershell wrapper for the Healthchecks.io v3 API

## healthcheckspwsh

### [Get-Check](./Management/checks/Get-Check.md)

Get details about one or more Healthchecks checks by UUID, slug, or tag.

### [Get-CheckFlips](./Management/flips/Get-CheckFlips.md)

List status changes (flips) for a Healthchecks check by UUID or unique key.

### [Get-CheckPingBody](./Management/pings/Get-CheckPingBody.md)

Get the logged body of a specific ping for a Healthchecks check.

### [Get-CheckPings](./Management/pings/Get-CheckPings.md)

List pings for a specific Healthchecks check by UUID.

### [Get-IntegrationList](./Management/integrations/Get-IntegrationList.md)

List all integrations (channels) for the Healthchecks project.

### [Get-ProjectBadges](./Management/badges/Get-ProjectBadges.md)

List all badge URLs for tags in the Healthchecks project.

### [New-Check](./Management/checks/New-Check.md)

Create a new Healthchecks check (Simple or Cron).

### [Remove-Check](./Management/checks/Remove-Check.md)

Remove (delete) a Healthchecks check by UUID.

### [Resume-Check](./Management/checks/Resume-Check.md)

Resume (unpause) a Healthchecks check by UUID.

### [Send-Check](./Send-Check.md)

Send a ping to a Healthchecks check by UUID or PingKey/Slug.

### [Set-Check](./Management/checks/Set-Check.md)

Update an existing Healthchecks check by UUID.

### [Suspend-Check](./Management/checks/Suspend-Check.md)

Pause (suspend) a Healthchecks check by UUID.

### [Test-ChecksDB](./Management/service status/Test-ChecksDB.md)

Test the Healthchecks database connection/status endpoint.

