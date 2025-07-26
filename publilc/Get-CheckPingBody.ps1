function Get-CheckPingBody {
    <#
    .SYNOPSIS
        Get the logged body of a specific ping for a Healthchecks check.

    .DESCRIPTION
        Retrieves the raw body content of a specific ping for a check from a Healthchecks instance using the API v3. The response is always plain text.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER UUID
        The UUID of the check.

    .PARAMETER PingNumber
        The sequence number of the ping to retrieve the body for.

    .EXAMPLE
        Get-CheckPingBody -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc" -PingNumber 397

        Retrieves the logged body of ping 397 for the specified check.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Body, and Success properties.

    .NOTES
        Returns plain text body. All parameters are required.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl,
        [Parameter(Mandatory)]
        [string]$UUID,
        [Parameter(Mandatory)]
        [int]$PingNumber
    )

    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/checks/$UUID/pings/$PingNumber/body"
    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UserAgent $userAgent -Method Get -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "The request succeeded" }
            403 { "Access denied, wrong API key" }
            404 { "The specified resource does not exist" }
            503 { "External object storage service is unavailable, please try later" }
            default { "Unknown error" }
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Body = $response.Content
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $body = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                403 { "Access denied, wrong API key" }
                404 { "The specified resource does not exist" }
                503 { "External object storage service is unavailable, please try later" }
                default { $_.Exception.Message }
            }
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $body = $reader.ReadToEnd()
            } catch { $body = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Body = $body
            Success = $false
        }
    }
}
