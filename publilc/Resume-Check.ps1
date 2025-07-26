function Resume-Check {
    <#
    .SYNOPSIS
        Resume (unpause) a Healthchecks check by UUID.

    .DESCRIPTION
        Resumes a paused check in a Healthchecks instance using the API v3. The check will start accepting pings again.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER UUID
        The UUID of the check to resume.

    .EXAMPLE
        Resume-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc"

        Resumes the check with the specified UUID.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, and Success properties.

    .NOTES
        Only works for checks you have permission to manage. Returns success if the check is resumed.
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
    $url = "$base/api/v3/checks/$UUID/resume"

    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UserAgent $userAgent -Method Post -Body '' -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "200 OK (The operation was successful.)" }
            401 { "401 Unauthorized (The API key is either missing or invalid.)" }
            403 { "403 Forbidden (Access denied, wrong API key.)" }
            404 { "404 Not Found (The specified check does not exist.)" }
            409 { "409 Conflict (The specified check is currently not in a paused state.)" }
            default { "$($response.StatusCode)" }
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                401 { "401 Unauthorized (The API key is either missing or invalid.)" }
                403 { "403 Forbidden (Access denied, wrong API key.)" }
                404 { "404 Not Found (The specified check does not exist.)" }
                409 { "409 Conflict (The specified check is currently not in a paused state.)" }
                default { "$status ($($_.Exception.Message))" }
            }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Success = $false
        }
    }
}
