<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Create Registry Value for Remote File Share and PSEXEC
    Set to 1 for Disable (no remote admin share allowed), Set to 0 for Enable (remote admin share allowed). Be warned only use this setting if absolutely required and you understand the implications.

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

        Get-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" | New-ItemProperty -Name LocalAccountTokenFilterPolicy -Value 1 -PropertyType Dword
    
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