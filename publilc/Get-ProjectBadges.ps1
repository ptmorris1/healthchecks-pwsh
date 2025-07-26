function Get-ProjectBadges {
    <#
    .SYNOPSIS
        List all badge URLs for tags in the Healthchecks project.

    .DESCRIPTION
        Retrieves a map of all tags in the project, with badge URLs for each tag and format (svg, json, shields, etc.) using the API v3.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .EXAMPLE
        Get-ProjectBadges -ApiKey $apiKey -BaseUrl "https://checks.example.com"

        Lists all badge URLs for the project.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Badges, and Success properties.

    .NOTES
        Only works for projects you have permission to view. All parameters are required.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl
    )

    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/badges/"
    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UserAgent $userAgent -Method Get -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "The request succeeded" }
            401 { "The API key is either missing or invalid" }
            default { "Unknown error" }
        }
        $badges = $null
        try {
            $body = $response.Content | ConvertFrom-Json
            if ($body.badges) {
                $badges = $body.badges
            } elseif ($body -is [System.Collections.IEnumerable]) {
                $badges = $body
            } else {
                $badges = @($body)
            }
        } catch { $badges = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Badges = $badges
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $badges = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                401 { "The API key is either missing or invalid" }
                default { $_.Exception.Message }
            }
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $body = $reader.ReadToEnd() | ConvertFrom-Json
                if ($body.badges) {
                    $badges = $body.badges
                } elseif ($body -is [System.Collections.IEnumerable]) {
                    $badges = $body
                } else {
                    $badges = @($body)
                }
            } catch { $badges = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Badges = $badges
            Success = $false
        }
    }
}