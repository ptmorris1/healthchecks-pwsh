---
title: Home
hide:
  - navigation
---
# HealthchecksPwsh

![PowerShell](https://img.shields.io/badge/PowerShell-0078d4?logo=powershell&logoColor=white&style=flat-square)
![API](https://img.shields.io/badge/API-v3-blueviolet?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue?style=flat-square)

## 📖 Introduction

[Healthchecks.io](https://healthchecks.io) is a free and open-source service for monitoring scheduled jobs (cron, Windows Scheduled Tasks, etc.). It notifies you if your scripts or scheduled tasks do not run on time, providing peace of mind for system administrators and developers.

**HealthchecksPwsh** is a PowerShell module that provides a modern, user-friendly interface to the Healthchecks v3 API, supporting both healthchecks.io and self-hosted instances. It enables you to manage checks, integrations, badges, and send pings directly from PowerShell.

## ✨ Features

- 🚦 Full coverage of Healthchecks v3 Management and Ping APIs
- 📝 Create, update, pause, resume, and delete checks
- 📊 List pings, get ping body, and view status flips
- 🔗 Manage integrations (channels) and project badges
- 📡 Send pings (success, start, fail, log, exit status) by UUID or slug
- 🛡️ Robust error handling and output as `PSCustomObject`
- 🧩 Consistent User-Agent and parameter validation
- 📚 Comment-based help for every function
- 🌍 Works with both healthchecks.io and self-hosted servers

!!! important "API Key Required"
    You must have a valid Healthchecks API key and base URL to use most cmdlets. See the [Healthchecks API docs](https://healthchecks.io/docs/api/) for details.

## 🚀 Quick Start

1. **Install the module from PowerShell Gallery:**

   ```powershell
   Install-PSResource -Name HealthchecksPwsh -Repository PSGallery -Scope CurrentUser
   # or, for older PowerShell versions:
   # Install-Module -Name HealthchecksPwsh -Repository PSGallery -Scope CurrentUser
   ```

2. **List all checks:**

   ```powershell
   Get-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com"
   ```

3. **Send a success ping:**

   ```powershell
   Send-Check -UUID "<uuid>" -BaseUrl "https://checks.example.com"
   ```

4. **Create a new check:**

   ```powershell
   New-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -Name "Backup Job" -Tags "prod" -Timeout 3600 -Grace 300
   ```

!!! tip "Get Help for Any Cmdlet"
    [Send-Check](Send-Check.md) or [Manage]() your checks or read about the [full list of functions](healthcheckspwsh.md)
