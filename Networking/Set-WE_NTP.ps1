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
    $Computers = ""
    $NTP_PeerList = "0.nz.pool.ntp.org 1.nz.pool.ntp.org 2.nz.pool.ntp.org 3.nz.pool.ntp.org" 
    $PrimaryDNS = ""
    $SecondaryDNS = ""

}

Process {

    Try {
       
        Foreach ($Computer in $Computers) {

            Invoke-Command -ComputerName $Computer {

                $EthernetAdapter = Get-WmiObject -Class win32_networkadapter -Filter "AdapterType like 'Ethernet%'" | Select-Object -ExpandProperty NetConnectionID
    
                netsh int ip set dnsservers $EthernetAdapter static $PrimaryDNS primary
    
                netsh int ip add dnsservers $EthernetAdapter Index=2 $SecondaryDNS

                Set-Service -Name W32Time -StartupType Automatic

                Start-Service -Name W32Time

                w32tm /config /syncfromflags:manual /manualpeerlist:$NTP_PeerList /update

                w32tm /resync /rediscover

                Get-Date

            }
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