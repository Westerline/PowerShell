<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    This is a more detailed description of the script. # The starting ErrorActionPreference will be saved and the current sets it to 'Stop'.

.PARAMETER UseExitCode
    This script is used to reset the dual monitor configuration for Windows. Add a backup function for the registry keys.

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
    $Value1 = HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration
    $Value2 = HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity
}

Process {

    Try {

        Remove-ItemProperty -path $Value1, $Value2

    }

    Catch [SpecificException] {
        
    }

    Catch {

        "$Value1 or $Value2 does not exist" 

    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}