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
        $regKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
        Set-ItemProperty -path $regKey ProxyEnable -value 1 -ErrorAction Stop
        $regKey_Status = Get-ItemProperty -path $regKey ProxyEnable -ErrorAction Stop
        $Properties = [Ordered] @{
            ComputerName = ($Env:COMPUTERNAME)
            ProxyEnable  = ($regKey_Status.ProxyEnable)
        }
    }

    Catch [SpecificException] {
        
    }

    Catch {

        $Properties = [Ordered] @{
            ComputerName = ($Env:COMPUTERNAME)
            Property2    = 'Test Failed'
        }

    }

    Finally {

        ($Object = New-Object -TypeName PSObject -Property $Properties) | Out-File $LogPath1

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}