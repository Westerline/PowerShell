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
    Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

[CmdletBinding()]

param (
    [Parameter(Mandatory = $True)]
    [Alias('hostname')]
    [string]$computername,
    [ValidateSet(2, 3)]
    [int]$drivetype = 3
)

BEGIN {
    # This saves the starting ErrorActionPreference and then sets it to 'Stop'.
    $startErrorActionPreference = $errorActionPreference
    $errorActionPreference = 'Stop'
    # This gets the current path and name of the script.
    $invocation = (Get-Variable MyInvocation).Value
    $scriptPath = Split-Path $invocation.MyCommand.Path
    $scriptName = $invocation.MyCommand.Name
    #Write-Output "Running `"$scriptPath\$scriptName`"..." -BackgroundColor Black -ForegroundColor Green
}
PROCESS {
    try {
        # Enter your code here.
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