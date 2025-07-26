function Get-Check {
    <#
    .SYNOPSIS
        Get details about one or more Healthchecks checks by UUID, slug, or tag.

    .DESCRIPTION
        Retrieves information about checks from a Healthchecks instance using the API v3. You can query by UUID (for a single check), by slug, or by one or more tags. If UUID is specified, Slug and Tag must not be used.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance (e.g., https://checks.example.com).

    .PARAMETER Slug
        (Optional) The slug of the check to retrieve.

    .PARAMETER Tag
        (Optional) One or more tags to filter checks by. Accepts an array of strings.

    .PARAMETER UUID
        (Optional) The UUID of the check to retrieve. If specified, Slug and Tag must not be used.

    .EXAMPLE
        Get-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

        Retrieves the check with the specified UUID.

    .EXAMPLE
        Get-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -Tag "prod","db"

        Retrieves all checks with the tags "prod" and "db".

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Checks, and Success properties.

    .NOTES
        If UUID is specified, do not specify Slug or Tag. All parameters except ApiKey and BaseUrl are optional.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl,
        [string]$Slug,
        [string[]]$Tag,
        [string]$UUID
    )

    # Validate exclusivity: UUID cannot be used with Slug or Tag
    if ($UUID -and ($Slug -or $Tag)) {
        throw "If -UUID is specified, do not specify -Slug or -Tag."
    }

    # Ensure BaseUrl does not end with a slash
    $base = $BaseUrl.TrimEnd('/')
    $apiPath = "/api/v3/checks/"

    if ($UUID) {
        $url = "$base$apiPath$UUID"
    } else {
        $fullBaseUrl = "$base$apiPath"
        # Build query string
        $query = @()
        if ($Slug) { $query += "slug=$Slug" }
        if ($Tag)  { foreach ($t in $Tag) { $query += "tag=$t" } }
        $url = $fullBaseUrl
        if ($query.Count) {
            $url += "?" + ($query -join '&')
        }
    }

    # Prepare headers
    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UserAgent $userAgent -Method Get -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "The request succeeded" }
            400 { "Invalid query parameters" }
            401 { "The API key is either missing or invalid" }
            403 { "Access denied, wrong API key" }
            404 { "The specified resource does not exist" }
            503 { "External object storage service is unavailable, please try later" }
            default { "Unknown error" }
        }
        $body = $null
        $expandedChecks = $null
        try {
            $body = $response.Content | ConvertFrom-Json
            if ($body.checks) {
                $expandedChecks = $body.checks
            } elseif ($body -is [System.Collections.IEnumerable]) {
                $expandedChecks = $body
            } else {
                $expandedChecks = @($body)
            }
        } catch { $expandedChecks = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Checks = $expandedChecks
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $expandedChecks = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                400 { "Invalid query parameters" }
                401 { "The API key is either missing or invalid" }
                403 { "Access denied, wrong API key" }
                404 { "The specified resource does not exist" }
                503 { "External object storage service is unavailable, please try later" }
                default { $_.Exception.Message }
            }
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $body = $reader.ReadToEnd() | ConvertFrom-Json
                if ($body.checks) {
                    $expandedChecks = $body.checks
                } elseif ($body -is [System.Collections.IEnumerable]) {
                    $expandedChecks = $body
                } else {
                    $expandedChecks = @($body)
                }
            } catch { $expandedChecks = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Checks = $expandedChecks
            Success = $false
        }
    }
}