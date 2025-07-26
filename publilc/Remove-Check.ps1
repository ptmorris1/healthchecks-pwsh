function Remove-Check {
    <#
    .SYNOPSIS
        Remove (delete) a Healthchecks check by UUID.

    .DESCRIPTION
        Deletes a check from a Healthchecks instance using the API v3. The check and its pings will be permanently removed.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER UUID
        The UUID of the check to delete.

    .EXAMPLE
        Remove-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

        Deletes the check with the specified UUID.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, DeletedCheck, and Success properties.

    .NOTES
        Only works for checks you have permission to manage. Returns success if the check is deleted.
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
    $url = "$base/api/v3/checks/$UUID"

    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UserAgent $userAgent -Method Delete -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "200 OK (The check was successfully deleted.)" }
            401 { "401 Unauthorized (The API key is either missing or invalid.)" }
            403 { "403 Forbidden (Access denied, wrong API key.)" }
            404 { "404 Not Found (The specified check does not exist.)" }
            default { "$($response.StatusCode)" }
        }
        $body = $null
        try { $body = $response.Content | ConvertFrom-Json } catch { $body = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            DeletedCheck = $body
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $body = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                401 { "401 Unauthorized (The API key is either missing or invalid.)" }
                403 { "403 Forbidden (Access denied, wrong API key.)" }
                404 { "404 Not Found (The specified check does not exist.)" }
                default { "$status ($($_.Exception.Message))" }
            }
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $body = $reader.ReadToEnd() | ConvertFrom-Json
            } catch { $body = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            DeletedCheck = $body
            Success = $false
        }
    }
}
