<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Enable RDP With NLA
    $RDPEnable - Set to 1 to enable remote desktop connections, 0 to disable
    $RDPFirewallOpen - Set to 1 to open RDP firewall port(s), 0 to close
    $NLAEnable - Set to 1 to enable, 0 to disable
    Section 1: Remote Desktop Connections
    Section 2: NLA (Network Level Authentication)
    Section 3: Recreate the WMI object so we can read out the (hopefully changed) setting

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

Function Set-WE_RemoteDesktop {

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $False)]
        [Alias('Transcript')]
        [string]$TranscriptFile,

        [Parameter(Mandatory = $True)]
        [Alias('HostName')]
        [ValidateNotNullorEmpty()]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $False)]
        [Alias('HostName')]
        [ValidateNotNullorEmpty()]
        [Boolean]$TerminalServices

    )

    Begin {

        Start-Transcript $TranscriptFile  -Append -Force
        $StartErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        $ComputerName = "Localhost"

    }

    Process {

        Try {
            
            Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\‘ -Name “fDenyTSConnections” -Value 0

            Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\‘ -Name “UserAuthentication” -Value 1

            Enable-NetFirewallRule -DisplayGroup “Remote Desktop”

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

}