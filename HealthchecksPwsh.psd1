@{
    ModuleVersion   = '1.0.1'
    Guid            = '7da498f6-4c96-4146-8730-febfc16920a4'
    CompanyName     = 'Patrick Morris '
    Copyright       = '2025 Patrick Morris'
    Author          = 'Patrick Morris'
    AliasesToExport = '*'
    RootModule      = 'HealthchecksPwsh.psm1'
    Description     = 'Powershell wrapper for the Healthchecks.io v3 API'
    FileList             = @('HealthchecksPwsh.psm1', 'HealthchecksPwsh.psd1')
    PowerShellVersion    = '7.5'
    CompatiblePSEditions = @('Core')
    PrivateData     = @{
        PSData = @{
            Tags         = 'Windows', 'Healthchecks.io', 'PowerShell', 'PSEdition_Core', 'Healthchecks'
            ProjectURI   = 'https://github.com/ptmorris1/healthchecks-pwsh'
            LicenseURI   = 'https://github.com/ptmorris1/healthchecks-pwsh/blob/main/LICENSE'            
            ReleaseNotes = @'
# Changelog

All notable changes to this project will be documented in this file.

## [1.0.1] - 2025-07-26
### Fixed
- Fixed typo in the `public` folder name.

## [1.0.0] - 2025-07-26
### Added
- Initial release of `healthchecks-pwsh` PowerShell module.
- Full coverage of Healthchecks v3 Management API:
  - List, get, create, update, pause, resume, and delete checks.
  - List pings, get ping body, list flips (status changes).
  - List integrations (channels) and project badges.
  - Check database connectivity.
- Full support for Ping API:
  - Send pings (success, start, fail, log, exit status) by UUID or slug.
- Robust error handling and output as `PSCustomObject`.
- Consistent User-Agent and parameter validation.
- Comment-based help for every function.
- Supports both Healthchecks.io and self-hosted instances.
- Modern, user-friendly documentation and examples.

---

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
'@
        }
    }
}

