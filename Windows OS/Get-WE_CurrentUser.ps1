<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Use the below function to get the name of a currently logged on user.

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
    $Name = "Test"
    $Computers = Get-ADComputer -Filter Name -Like $Name | Sort-Object -Property Name | Select-Object -ExpandProperty Name

}

Process {

    ForEach ($Computer in $Computers) {

        Try {

            Get-WmiObject -ComputerName $Computer -Class Win32_ComputerSystem | Select-Object Name, Username, DNSHostName

            Write-Output "$Computer not found."
            
        }

        Catch [SpecificException] {
        
        }

        Catch {


        }

        Finally {

        }
    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}