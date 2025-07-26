function Send-Check {
    <#
    .SYNOPSIS
        Send a ping to a Healthchecks check by UUID or PingKey/Slug.

    .DESCRIPTION
        Sends a ping to a Healthchecks check using the API v3. Supports both UUID and PingKey/Slug methods, as well as run IDs, status switches, and log/exit status. Can also create a check if it does not exist (with -Create).

    .PARAMETER UUID
        (Optional) The UUID of the check to ping.

    .PARAMETER PingKey
        (Optional) The ping key for the check (used with Slug).

    .PARAMETER Slug
        (Optional) The slug for the check (used with PingKey).

    .PARAMETER BaseUrl
        The base URL of the Healthchecks instance.

    .PARAMETER RunID
        (Optional) The run ID to associate with the ping.

    .PARAMETER Start
        (Optional) Switch. Mark this ping as a "start" event.

    .PARAMETER Success
        (Optional) Switch. Mark this ping as a "success" event.

    .PARAMETER Failure
        (Optional) Switch. Mark this ping as a "failure" event.

    .PARAMETER Log
        (Optional) Switch. Mark this ping as a "log" event.

    .PARAMETER ExitStatus
        (Optional) The exit status code to send with the ping.

    .PARAMETER Create
        (Optional) Switch. If specified, create the check if it does not exist (PingKey/Slug only).

    .EXAMPLE
        Send-Check -UUID "f618072a-7bde-4eee-af63-71a77c5723bc" -BaseUrl "https://checks.example.com" -Start

        Sends a "start" ping to the check with the specified UUID.

    .EXAMPLE
        Send-Check -PingKey "abc123" -Slug "my-check" -BaseUrl "https://checks.example.com" -Create

        Sends a ping to the check with the specified PingKey and Slug, creating it if it does not exist.

    .OUTPUTS
        PSCustomObject with Url, StatusCode, StatusMessage, PingBodyLimit, and Success properties.

    .NOTES
        You must specify either UUID or both PingKey and Slug. The -Create switch cannot be used with UUID.
    #>
    [CmdletBinding()]
    param(
        [string]$UUID,
        [string]$PingKey,
        [string]$Slug,

        [Parameter(Mandatory)]
        [string]$BaseUrl,

        [string]$RunID,

        [switch]$Start,

        [switch]$Success,

        [switch]$Failure,

        [switch]$Log,

        [int]$ExitStatus,

        [switch]$Create
    )

    # Validate exclusivity and requireds
    if (($UUID -and ($PingKey -or $Slug)) -or ($Create -and $UUID)) {
        throw "You must specify either UUID or PingKey/Slug, not both. The -Create switch cannot be used with UUID."
    }
    if (($PingKey -and -not $Slug) -or ($Slug -and -not $PingKey)) {
        throw "Both -PingKey and -Slug must be specified together for the Slug method." 
    }
    if (-not $UUID -and -not ($PingKey -and $Slug)) {
        throw "You must specify either -UUID or both -PingKey and -Slug." 
    }

    # Ensure BaseUrl does not end with a slash
    $base = $BaseUrl.TrimEnd('/')

    # Build endpoint
    if ($PingKey -and $Slug) {
        $endpoint = "$base/ping/$PingKey/$Slug"
        if ($ExitStatus -ne $null) {
            $endpoint += "/$ExitStatus"
        } elseif ($Start) {
            $endpoint += "/start"
        } elseif ($Failure) {
            $endpoint += "/fail"
        } elseif ($Log) {
            $endpoint += "/log"
        }
        $query = ""
        if ($Create) { $query = "?create=1" }
        if ($RunID) {
            if ($query) {
                $query += "&rid=$RunID"
            } else {
                $query = "?rid=$RunID"
            }
        }
        $finalUrl = "$endpoint$query"
    } elseif ($UUID) {
        $endpoint = "$base/ping/$UUID"
        if ($ExitStatus -ne $null) {
            $endpoint += "/$ExitStatus"
        } elseif ($Start) {
            $endpoint += "/start"
        } elseif ($Failure) {
            $endpoint += "/fail"
        } elseif ($Log) {
            $endpoint += "/log"
        }
        $query = ""
        if ($RunID) {
            $query = "?rid=$RunID"
        }
        $finalUrl = "$endpoint$query"
    } else {
        throw "Invalid parameter combination. Could not determine endpoint to use."
    }

    $pwshVersion = $PSVersionTable.PSVersion.ToString()
    $userAgent = "HealthchecksPwsh/$pwshVersion"

    try {
        $response = Invoke-WebRequest -Uri $finalUrl -UserAgent $userAgent -Method Get -ErrorAction Stop
        $statusMsg = switch ($response.StatusCode) {
            200 { "200 OK (The request succeeded.)" }
            201 { "201 Created (A new check was automatically created, the request succeeded.)" }
            404 { if ($PingKey) { "404 Not Found (Could not find a check with the specified ping key and slug combination.)" } else { "404 Not Found (Could not find a check with the specified UUID.)" } }
            409 { "409 Ambiguous Slug (The slug matched multiple checks.)" }
            default { "$($response.StatusCode)" }
        }
        $result = [PSCustomObject]@{
            Url = $finalUrl
            StatusCode = $response.StatusCode
            StatusMessage = $statusMsg
            PingBodyLimit = $response.Headers["Ping-Body-Limit"]
            Success = ($response.StatusCode -eq 200 -or $response.StatusCode -eq 201)
        }
        $result
    } catch {
        $status = $null
        $statusMsg = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = $_.Exception.Response.StatusCode.value__
            $statusMsg = switch ($status) {
                404 { if ($PingKey) { "404 Not Found (Could not find a check with the specified ping key and slug combination.)" } else { "404 Not Found (Could not find a check with the specified UUID.)" } }
                409 { "409 Ambiguous Slug (The slug matched multiple checks.)" }
                default { "$status ($($_.Exception.Message))" }
            }
        } else {
            $statusMsg = $_.Exception.Message
        }
        $result = [PSCustomObject]@{
            Url = $finalUrl
            StatusCode = $status
            StatusMessage = $statusMsg
            PingBodyLimit = $null
            Success = $false
        }
        $result
    }
}