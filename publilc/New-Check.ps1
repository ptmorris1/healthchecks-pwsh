function New-Check {
    <#
    .SYNOPSIS
        Create a new Healthchecks check (Simple or Cron).

    .DESCRIPTION
        Creates a new check in a Healthchecks instance using the API v3. Supports all documented parameters for both Simple and Cron checks. If a matching check exists and the unique parameter is used, the check will be updated instead.

    .PARAMETER ApiKey
        The Healthchecks API key for authentication.

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER Name
        (Optional) Name for the new check.

    .PARAMETER Slug
        (Optional) Slug for the new check.

    .PARAMETER Tags
        (Optional) One or more tags for the new check. Accepts an array of strings.

    .PARAMETER Desc
        (Optional) Description of the check.

    .PARAMETER Timeout
        (Optional) The expected period of this check in seconds.

    .PARAMETER Grace
        (Optional) The grace period for this check in seconds.

    .PARAMETER Schedule
        (Optional) A cron or OnCalendar expression defining this check's schedule.

    .PARAMETER Tz
        (Optional) Server's timezone (used with schedule).

    .PARAMETER ManualResume
        (Optional) If true, check must be resumed manually after being paused.

    .PARAMETER Methods
        (Optional) Allowed HTTP methods for pings ("" or "POST").

    .PARAMETER Channels
        (Optional) Integrations to assign to the check ("*", "", UUIDs, or names).

    .PARAMETER Unique
        (Optional) Array of fields to enable upsert functionality.

    .PARAMETER StartKw
        (Optional) Keywords for classifying inbound email as "Start".

    .PARAMETER SuccessKw
        (Optional) Keywords for classifying inbound email as "Success".

    .PARAMETER FailureKw
        (Optional) Keywords for classifying inbound email as "Failure".

    .PARAMETER FilterSubject
        (Optional) Enables filtering of inbound email by subject.

    .PARAMETER FilterBody
        (Optional) Enables filtering of inbound email by body.

    .PARAMETER Subject
        (Optional, deprecated) Keywords for classifying email as "Success" by subject.

    .PARAMETER SubjectFail
        (Optional, deprecated) Keywords for classifying email as "Failure" by subject.

    .EXAMPLE
        New-Check -ApiKey $apiKey -BaseUrl "https://checks.example.com" -Name "Backups" -Tags "prod","www" -Timeout 3600 -Grace 60

        Creates a new check named "Backups" with tags "prod" and "www", a 1-hour timeout, and a 1-minute grace period.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, Check, and Success properties.

    .NOTES
        All parameters except ApiKey and BaseUrl are optional. If unique is used and a match is found, the check will be updated instead of created.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,
        [Parameter(Mandatory)]
        [string]$BaseUrl,
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
        [string[]]$Unique,
        [string]$StartKw,
        [string]$SuccessKw,
        [string]$FailureKw,
        [bool]$FilterSubject,
        [bool]$FilterBody,
        [string]$Subject,
        [string]$SubjectFail
    )

    $base = $BaseUrl.TrimEnd('/')
    $url = "$base/api/v3/checks/"
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
    if ($Unique) { $body.unique = $Unique }
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
            201 { "A new check was successfully created" }
            200 { "An existing check was found and updated" }
            400 { "The request is not well-formed, violates schema, or uses invalid field values" }
            401 { "The API key is either missing or invalid" }
            403 { "The account has hit its check limit" }
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
            Success = ($response.StatusCode -eq 201 -or $response.StatusCode -eq 200)
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
                403 { "The account has hit its check limit" }
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
