function Set-Check {
    <#
    .SYNOPSIS
        Update an existing Healthchecks check by UUID.

    .DESCRIPTION
        Updates a Healthchecks check using the API v3. Supports all documented fields, including tags (as array), timeout/grace (as int), schedule, timezone, manual resume, methods, channels, keywords, and subject filters. Returns the updated check object.

    .PARAMETER ApiKey
        The API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER UUID
        The UUID of the check to update.

    .PARAMETER Name
        (Optional) The name of the check.

    .PARAMETER Slug
        (Optional) The slug for the check.

    .PARAMETER Tags
        (Optional) Array of tags for the check.

    .PARAMETER Desc
        (Optional) Description of the check.

    .PARAMETER Timeout
        (Optional) Timeout in seconds.

    .PARAMETER Grace
        (Optional) Grace period in seconds.

    .PARAMETER Schedule
        (Optional) Cron schedule for the check.

    .PARAMETER Tz
        (Optional) Timezone for the schedule.

    .PARAMETER ManualResume
        (Optional) Boolean. If true, check must be manually resumed.

    .PARAMETER Methods
        (Optional) Allowed HTTP methods for pings.

    .PARAMETER Channels
        (Optional) Notification channels.

    .PARAMETER StartKw
        (Optional) Start keywords for email integration.

    .PARAMETER SuccessKw
        (Optional) Success keywords for email integration.

    .PARAMETER FailureKw
        (Optional) Failure keywords for email integration.

    .PARAMETER FilterSubject
        (Optional) Boolean. Filter on email subject.

    .PARAMETER FilterBody
        (Optional) Boolean. Filter on email body.

    .PARAMETER Subject
        (Optional) Custom subject for success notifications.

    .PARAMETER SubjectFail
        (Optional) Custom subject for failure notifications.

    .EXAMPLE
        Set-Check -ApiKey "your-api-key" -BaseUrl "https://checks.example.com" -UUID "f618072a-7bde-4eee-af63-71a77c5723bc" -Name "My Check" -Tags @("prod","api") -Timeout 3600 -Grace 900

        Updates the specified check with new name, tags, timeout, and grace period.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Check, and Success properties.

    .NOTES
        All parameters are optional except ApiKey, BaseUrl, and UUID. Only provided parameters are updated.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl,
        [Parameter(Mandatory)]
        [string]$UUID,
        [string]$Name,
        [string]$Slug,
        [string[]]$Tags,
        [string]$Desc,
        [int]$Timeout,
        [int]$Grace,
        [string]$Schedule,
        [string]$Tz,
        [bool]$ManualResume,
        [string]$Methods,
        [string]$Channels,
        [string]$StartKw,
        [string]$SuccessKw,
        [string]$FailureKw,
        [bool]$FilterSubject,
        [bool]$FilterBody,
        [string]$Subject,
        [string]$SubjectFail
    )

    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/checks/$UUID"
    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"
    $headers = @{ 'X-Api-Key' = $ApiKey }

    $body = @{}
    if ($Name) { $body.name = $Name }
    if ($Slug) { $body.slug = $Slug }
    if ($Tags) { $body.tags = ($Tags -join ' ') }
    if ($Desc) { $body.desc = $Desc }
    if ($Timeout) { $body.timeout = [int]$Timeout }
    if ($Grace) { $body.grace = [int]$Grace }
    if ($Schedule) { $body.schedule = $Schedule }
    if ($Tz) { $body.tz = $Tz }
    if ($PSBoundParameters.ContainsKey('ManualResume')) { $body.manual_resume = $ManualResume }
    if ($Methods) { $body.methods = $Methods }
    if ($Channels) { $body.channels = $Channels }
    if ($StartKw) { $body.start_kw = $StartKw }
    if ($SuccessKw) { $body.success_kw = $SuccessKw }
    if ($FailureKw) { $body.failure_kw = $FailureKw }
    if ($PSBoundParameters.ContainsKey('FilterSubject')) { $body.filter_subject = $FilterSubject }
    if ($PSBoundParameters.ContainsKey('FilterBody')) { $body.filter_body = $FilterBody }
    if ($Subject) { $body.subject = $Subject }
    if ($SubjectFail) { $body.subject_fail = $SubjectFail }

    $jsonBody = $body | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UserAgent $userAgent -Method Post -Body $jsonBody -ContentType 'application/json' -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "The check was successfully updated" }
            400 { "The request is not well-formed, violates schema, or uses invalid field values" }
            401 { "The API key is either missing or invalid" }
            403 { "Access denied, wrong API key" }
            404 { "The specified check does not exist" }
            default { "Unknown error" }
        }
        $result = $null
        try {
            $result = $response.Content | ConvertFrom-Json
        } catch { $result = $response.Content }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            Check = $result
            Success = ($response.StatusCode -eq 200)
        }
    } catch {
        $status = $null
        $statusMsg = $null
        $result = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                400 { "The request is not well-formed, violates schema, or uses invalid field values" }
                401 { "The API key is either missing or invalid" }
                403 { "Access denied, wrong API key" }
                404 { "The specified check does not exist" }
                default { $_.Exception.Message }
            }
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $result = $reader.ReadToEnd() | ConvertFrom-Json
            } catch { $result = $null }
        } else {
            $statusMsg = $_.Exception.Message
        }
        [PSCustomObject]@{
            Url = $url
            StatusCode = $status
            StatusMessage = $statusMsg
            Check = $result
            Success = $false
        }
    }
}
