# healthchecks-pwsh

![PowerShell Gallery](https://img.shields.io/powershellgallery/v/HealthchecksPwsh?color=blue&logo=powershell)
![Downloads](https://img.shields.io/powershellgallery/dt/HealthchecksPwsh?color=purple)
![License](https://img.shields.io/github/license/ptmorris1/healthchecks-pwsh?color=green)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)

> [!TIP]
> **healthchecks-pwsh** is a PowerShell module for managing and monitoring [Healthchecks.io](https://healthchecks.io) and compatible self-hosted instances via the v3 API.

---

## 📦 Features

- Full coverage of Healthchecks v3 Management and Ping APIs
- Modern, robust error handling and output as `PSCustomObject`
- Supports both Healthchecks.io and self-hosted instances

---

## 🚀 Installation

```powershell
Install-PSResource -Name HealthchecksPwsh -Repository PSGallery -Scope CurrentUser
```

---


## 📚 Management API Function Mapping

| API Endpoint Description                | HTTP Method & Path                                                        | PowerShell Function      |
|-----------------------------------------|---------------------------------------------------------------------------|-------------------------|
| List existing checks                    | GET /api/v3/checks/                                                       | `Get-Check`             |
| Get a single check                      | GET /api/v3/checks/<uuid> or <unique_key>                                 | `Get-Check`             |
| Create a new check                      | POST /api/v3/checks/                                                      | `New-Check`             |
| Update an existing check                | POST /api/v3/checks/<uuid>                                                | `Set-Check`             |
| Pause monitoring of a check             | POST /api/v3/checks/<uuid>/pause                                          | `Suspend-Check`         |
| Resume monitoring of a check            | POST /api/v3/checks/<uuid>/resume                                         | `Resume-Check`          |
| Delete check                            | DELETE /api/v3/checks/<uuid>                                              | `Remove-Check`          |
| List check's logged pings               | GET /api/v3/checks/<uuid>/pings/                                          | `Get-CheckPings`        |
| Get a ping's logged body                | GET /api/v3/checks/<uuid>/pings/<n>/body                                  | `Get-CheckPingBody`     |
| List check's status changes (flips)     | GET /api/v3/checks/<uuid>/flips/ or <unique_key>/flips/                   | `Get-CheckFlips`        |
| List existing integrations              | GET /api/v3/channels/                                                     | `Get-IntegrationList`   |
| List project's badges                   | GET /api/v3/badges/                                                       | `Get-ProjectBadges`     |
| Check database connectivity             | GET /api/v3/status/                                                       | `Test-ChecksDB`         |

---

## 📡 Ping API Function Mapping

| Ping Action                  | Endpoint Format (UUID)         | Endpoint Format (PingKey/Slug)         | PowerShell Function |
|------------------------------|-------------------------------|----------------------------------------|--------------------|
| Success                      | /ping/&lt;uuid&gt;              | /ping/&lt;ping-key&gt;/&lt;slug&gt;         | `Send-Check`       |
| Start                        | /ping/&lt;uuid&gt;/start         | /ping/&lt;ping-key&gt;/&lt;slug&gt;/start  | `Send-Check`       |
| Failure                      | /ping/&lt;uuid&gt;/fail          | /ping/&lt;ping-key&gt;/&lt;slug&gt;/fail   | `Send-Check`       |
| Log                          | /ping/&lt;uuid&gt;/log           | /ping/&lt;ping-key&gt;/&lt;slug&gt;/log    | `Send-Check`       |
| Report script's exit status  | /ping/&lt;uuid&gt;/&lt;exit-status&gt; | /ping/&lt;ping-key&gt;/&lt;slug&gt;/&lt;exit-status&gt; | `Send-Check`       |

---

## 📝 Usage Example

```powershell
# List all checks
Get-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com"

# Create a new check
New-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -Name "Backup Job" -Tags "prod" -Timeout 3600 -Grace 300

# Pause a check
Suspend-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "<uuid>"

# Send a success ping
Send-Check -UUID "<uuid>" -BaseUrl "https://checks.example.com"

# Send a start ping by slug
Send-Check -PingKey "<ping-key>" -Slug "<slug>" -BaseUrl "https://checks.example.com" -Start
```

---

> [!IMPORTANT]
> All cmdlets require at least `-ApiKey` and `-BaseUrl` parameters (except `Send-Check`, which uses ping endpoints). See comment-based help (`Get-Help <FunctionName> -Full`) for details and examples.

---

## 📖 Documentation

For full documentation, usage examples, and cmdlet reference, check out the online docs:

👉 [HealthchecksPwsh Documentation](https://ptmorris1.github.io/healthchecks-pwsh/index.html)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or PR.

---

## 🔗 Resources

- [Healthchecks API v3 Docs](https://healthchecks.io/docs/api/)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/HealthchecksPwsh)
