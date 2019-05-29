<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    This is a more detailed description of the script.

.PARAMETER UseExitCode
    This switch will cause the script to close after the error is logged if an error occurs.

    It is used to pass the error number back to the task scheduler.

.EXAMPLE
    Error handling.ps1

    Description
    ----------
    This would be the description for the example.

.NOTES
    Author: 
    Updated: 
    Date Started: 
#>

[CmdletBinding()]

param (
    [Parameter(Mandatory = $True)]
    [Alias('ReferenceObject')]
    [string]$Inf_ReferenceObject,
    [Parameter(Mandatory = $True)]
    [Alias('DifferenceObject')]
    [string]$Inf_DifferenceObject
    <#,
    [Parameter(Mandatory = $False)]
    [Boolean]$Recurse#>
)

BEGIN {
    # This saves the starting ErrorActionPreference and then sets it to 'Stop'.
    $errorActionPreference = 'Stop'
    $startErrorActionPreference = $errorActionPreference
    
    # This gets the current path and name of the script.
    $invocation = (Get-Variable MyInvocation).Value
    $ScriptPath = Split-Path $invocation.MyCommand.Path
    $ScriptName = $invocation.MyCommand.Name
    Write-Host "Running $ScriptPath\$ScriptName..." -BackgroundColor Black -ForegroundColor Green
}

PROCESS {
    try {
        # Enter your code here.
        Compare
    }
    catch {
        $errorMessage = "$scriptName caught an exception on $($ENV:COMPUTERNAME):"
        $errorMessage += "`n" + "`n"
        $errorMessage += "Exception Type: $($_.Exception.GetType().FullName)"
        $errorMessage += "`n" + "`n"
        $errorMessage += "Exception Message: $($_.Exception.Message)"

        Write-Error $errorMessage -ErrorAction Continue
        <# Log error
        Write-Verbose "Logging the script's error..."
# Log error - EventLog
        #An event log source needs to be preconfigured to use this.
        Write-EventLog `
            -EventId $AlertNumber `
            -LogName $LogName `
            -Source $EventSource `
            -Message $errorMessage `
            -EntryType Error
# Log error - Email
        # This will attempt to send an immediate alert about the error.
        # The EventLog also needs to log the error because this one may not be sent.
        #use Send-MailMessage
#>
        Start-Sleep -Seconds 3
        Write-Debug $errorMessage
        if ( $UseExitCode ) {
            exit 1
        }
    }
}

END {
    # This resets the ErrorActionPreference to the starting value.
    $errorActionPreference = $startErrorActionPreference
}