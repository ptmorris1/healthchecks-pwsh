function Test-ChecksDB {
    <#
    .SYNOPSIS
        Test the Healthchecks database connection/status endpoint.

    .DESCRIPTION
        Calls the /api/v3/status/ endpoint of a Healthchecks instance to test the database connection. Returns a PSCustomObject with the result and status message.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .EXAMPLE
        Test-ChecksDB -BaseUrl "https://checks.example.com"

        Tests the Healthchecks instance's database connection and returns the result.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, and Success properties.

    .NOTES
        Useful for monitoring or troubleshooting Healthchecks server connectivity.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$BaseUrl
    )

    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/status/"
    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"

    try {
        $response = Invoke-WebRequest -Uri $url -UserAgent $userAgent -Method Get -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "The request succeeded" }
            500 { "Test database query did not succeed" }
            default { "Unknown error" }
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
                500 { "Test database query did not succeed" }
                default { $_.Exception.Message }
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
