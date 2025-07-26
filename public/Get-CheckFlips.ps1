function Get-CheckFlips {
    <#
    .SYNOPSIS
        List status changes (flips) for a Healthchecks check by UUID or unique key.

    .DESCRIPTION
        Retrieves a list of status changes (flips) for a check from a Healthchecks instance using the API v3. Supports time filtering via seconds, start, and end parameters.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER UUID
        The UUID or unique key of the check to list flips for.

    .PARAMETER Seconds
        (Optional) Returns flips from the last specified number of seconds.

    .PARAMETER Start
        (Optional) Returns flips newer than the specified UNIX timestamp.

    .PARAMETER End
        (Optional) Returns flips older than the specified UNIX timestamp.

    .EXAMPLE
        Get-CheckFlips -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc" -Seconds 3600

        Lists flips for the specified check from the last hour.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Flips, and Success properties.

    .NOTES
        All parameters except ApiKey, BaseUrl, and UUID are optional. Time filters are supported.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl,
        [Parameter(Mandatory)]
        [string]$UUID, # UUID or unique key
        [int]$Seconds,
        [int]$Start,
        [int]$End
    )

    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/checks/$UUID/flips/"
    $query = @()
    if ($Seconds) { $query += "seconds=$Seconds" }
    if ($Start)   { $query += "start=$Start" }
    if ($End)     { $query += "end=$End" }
    if ($query.Count) {
        $url += "?" + ($query -join '&')
    }
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
        $flips = $null
        try {
            $body = $response.Content | ConvertFrom-Json
            if ($body.flips) {
                $flips = $body.flips
            } elseif ($body -is [System.Collections.IEnumerable]) {
                $flips = $body
            } else {
                $flips = @($body)
            }
        } catch { $flips = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Flips = $flips
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $flips = $null
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
                if ($body.flips) {
                    $flips = $body.flips
                } elseif ($body -is [System.Collections.IEnumerable]) {
                    $flips = $body
                } else {
                    $flips = @($body)
                }
            } catch { $flips = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Flips = $flips
            Success = $false
        }
    }
}
