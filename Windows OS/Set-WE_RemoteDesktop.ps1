<#
.DESCRIPTION
    Enable RDP With NLA
    $RDPEnable - Set to 1 to enable remote desktop connections, 0 to disable
    $RDPFirewallOpen - Set to 1 to open RDP firewall port(s), 0 to close
    $NLAEnable - Set to 1 to enable, 0 to disable
    Section 1: Remote Desktop Connections
    Section 2: NLA (Network Level Authentication)
    Section 3: Recreate the WMI object so we can read out the (hopefully changed) setting
#>

Function Set-WE_RemoteDesktop {

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True)]
        [Alias('HostName')]
        [ValidateNotNullorEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $False)]
        [Alias('HostName')]
        [ValidateNotNullorEmpty()]
        [Boolean]
        $TerminalServices

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $EnableRDP = Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\‘ -Name “fDenyTSConnections” -Value 0
            $NLA = Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\‘ -Name “UserAuthentication” -Value 1
            $Firewall = Enable-NetFirewallRule -DisplayGroup “Remote Desktop”
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                RDPStatus                  = $EnableRDP
                NetworkLevelAuthentication = $NLA
                FirewallStatus             = $Firewall
            }

        }

        Catch {

            Write-Verbose "Unable to set remote desktop connection settings on $Env:COMPUTERNAME."
            $Property = @{
                RDPStatus                  = 'Null'
                NetworkLevelAuthentication = 'Null'
                FirewallStatus             = 'Null'
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}