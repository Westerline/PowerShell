<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Section 1: Enable High Performance
    Section 2: 

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

        $P = Get-WmiObject -NS root\cimv2\power -Class win32_PowerPlan -Filter "ElementName ='High Performance'"
        $P.Activate()

        #Configure Power Settings
        powercfg.exe -x -monitor-timeout-ac 15
        powercfg.exe -x -monitor-timeout-dc 15
        powercfg.exe -x -disk-timeout-ac 0
        powercfg.exe -x -disk-timeout-dc 0
        powercfg.exe -x -standby-timeout-ac 0
        powercfg.exe -x -standby-timeout-dc 0
        powercfg.exe -x -hibernate-timeout-ac 0
        powercfg.exe -x -hibernate-timeout-dc 0
        Write-Host "Power Settings changed sucessfully"
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