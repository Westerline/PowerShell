<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    This is a more detailed description of the script. # The starting ErrorActionPreference will be saved and the current sets it to 'Stop'.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Scriptname.ps1

    Description
    ----------
    This would be the description for the example.

.NOTES
    Author: Wesley Esterline
    Resources: 
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

[CmdletBinding()]

Param (

    [Parameter(Mandatory = $False)]
    [Alias('Transcript')]
    [string]$TranscriptFile

)

Begin {
    Start-Transcript $TranscriptFile  -Append -Force
    $StartErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

}

Process {

    Try {
       
        $ErrorMessage = "$ScriptName caught an exception on $($ENV:COMPUTERNAME):"
        $ErrorMessage += "`n" + "`n"
        $ErrorMessage += "Exception Type: $($_.Exception.GetType().FullName)"
        $ErrorMessage += "`n" + "`n"
        $ErrorMessage += "Exception Message: $($_.Exception.Message)"

        Write-Error $ErrorMessage -ErrorAction Continue
        Write-Verbose "Logging the script's error..."
        #An event log parameter needs to be preconfigured to use this.
        Write-EventLog `
            -EventId $AlertNumber `
            -LogName $LogName `
            -Source $EventSource `
            -Message $ErrorMessage `
            -EntryType Error
        # Log error - Email
        # This will attempt to send an immediate alert about the error.
        # The EventLog also needs to log the error because this one may not be sent.
        #use Send-MailMessage
        #>
        Start-Sleep -Seconds 3
        Write-Debug $ErrorMessage
        If ( $UseExitCode ) {
            exit 1
        }

    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}