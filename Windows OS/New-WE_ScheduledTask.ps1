<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Example script to show how to run a process in the same sesssion as a remote user via Task Scheduler. Translate to PowerShell

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
    $Sessions = New-PSSession -ComputerName (Get-Content C:\test.txt)

}

Process {

    Try {

        Invoke-Command -Session $Sessions -ScriptBlock {
            

            $StartTime = (get-date).AddMinutes(1).ToString("HH:mm")

            $StartDate = Get-Date -UFormat "%d/%m/%Y"

            Write-Output "Creating scheduled task for test.exe on $Env:Computername @ $StartTime $StartDate"

            schtasks /create /tn "Start Test.exe" /tr c:\temp\test.exe /sc once /st $StartTime /sd $StartDate /ru test /rp test

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