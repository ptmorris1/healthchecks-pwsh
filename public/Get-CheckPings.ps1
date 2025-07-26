function Get-CheckPings {
    <#
    .SYNOPSIS
        List pings for a specific Healthchecks check by UUID.

    .DESCRIPTION
        Retrieves a list of pings for a check from a Healthchecks instance using the API v3. Returns all pings for the specified check.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER UUID
        The UUID of the check to list pings for.

    .EXAMPLE
        Get-CheckPings -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

        Lists all pings for the specified check.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Pings, and Success properties.

    .NOTES
        Only works for checks you have permission to view. All parameters are required.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl,
        [Parameter(Mandatory)]
        [string]$UUID
    )

    # Ensure BaseUrl does not end with a slash
    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/checks/$UUID/pings/"

    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -UserAgent $userAgent -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "The request succeeded" }
            401 { "The API key is either missing or invalid" }
            404 { "The specified resource does not exist" }
            default { "Unknown error" }
        }
        $body = $null
        $pings = $null
        try {
            $body = $response.Content | ConvertFrom-Json
            if ($body.pings) {
                $pings = $body.pings
            } elseif ($body -is [System.Collections.IEnumerable]) {
                $pings = $body
            } else {
                $pings = @($body)
            }
        } catch { $pings = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Pings = $pings
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $pings = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                401 { "The API key is either missing or invalid" }
                404 { "The specified resource does not exist" }
                default { $_.Exception.Message }
            }
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $body = $reader.ReadToEnd() | ConvertFrom-Json
                if ($body.pings) {
                    $pings = $body.pings
                } elseif ($body -is [System.Collections.IEnumerable]) {
                    $pings = $body
                } else {
                    $pings = @($body)
                }
            } catch { $pings = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Pings = $pings
            Success = $false
        }
    }
}
