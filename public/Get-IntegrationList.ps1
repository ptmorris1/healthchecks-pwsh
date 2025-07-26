function Get-IntegrationList {
    <#
    .SYNOPSIS
        List all integrations (channels) for the Healthchecks project.

    .DESCRIPTION
        Retrieves a list of all integrations (channels) configured in the Healthchecks project using the API v3.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .EXAMPLE
        Get-IntegrationList -ApiKey $apiKey -BaseUrl "https://checks.example.com"

        Lists all integrations for the project.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Integrations, and Success properties.

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
    $url = "$base/api/v3/channels/"
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
        $channels = $null
        try {
            $body = $response.Content | ConvertFrom-Json
            if ($body.channels) {
                $channels = $body.channels
            } elseif ($body -is [System.Collections.IEnumerable]) {
                $channels = $body
            } else {
                $channels = @($body)
            }
        } catch { $channels = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Integrations = $channels
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $channels = $null
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
                if ($body.channels) {
                    $channels = $body.channels
                } elseif ($body -is [System.Collections.IEnumerable]) {
                    $channels = $body
                } else {
                    $channels = @($body)
                }
            } catch { $channels = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Integrations = $channels
            Success = $false
        }
    }
}
