# Changelog

All notable changes to this project will be documented in this file.

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