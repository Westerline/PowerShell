<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Script to automatically attach the required database and configure required users.

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
       
        If (Test-Path 'C:\Database\Data\data.mdf') {

            Write-Output "Database file found." -Verbose

            Invoke-Sqlcmd -Query "CREATE DATABASE AKPOS ON (FILENAME = 'C:\Database\Data\data.mdf'), (FILENAME = 'C:\Database\Data\log.ldf') FOR ATTACH;" -Verbose

            Invoke-Sqlcmd -Query "CREATE LOGIN User WITH PASSWORD = $SecureString;" -Verbose

            Invoke-Sqlcmd -Query "EXEC master..sp_addsrvrolemember @loginame = N'User', @rolename = N'public';" -Verbose

            Write-Output "Database setup and configured." -Verbose

        }

        Else {

            Write-Warning "Database file not found." -Verbose

        }

    }

    Catch [SpecificException] {
        
    }

    Catch {

        Write-Warning 'A generic error occurred when attaching and configuring the database.' -Verbose
    }


    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
    
}