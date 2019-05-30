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
    $IPv4_Address = ""
    $Subnet = ""
    $Default_Gateway = ""
    $Primary_DNS = ""
    $Secondary_DNS = ""

}

Process {

    Try {

        If ($EthernetAdapter) {

            netsh.exe int ip set address $EthernetAdapter.InterfaceIndex static $IPv4_Address $Subnet $Default_Gateway 1

            netsh.exe int ip set dnsservers $EthernetAdapter.InterfaceIndex static $Primary_DNS primary

            netsh.exe int ip add dnsservers $EthernetAdapter.InterfaceIndex Index=2 $Secondary_DNS

            Write-Verbose 'The IP address settings were applied successfully.' -Verbose

        }
       
    }

    Catch [SpecificException] {
        
    }

    Catch {

        Write-Warning 'The IP address settings were not applied successfully.'

    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}