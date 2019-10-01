Function Set-WE_RemoteDesktop {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Enable RDP With NLA
        $RDPEnable - Set to 1 to enable remote desktop connections, 0 to disable
        $RDPFirewallOpen - Set to 1 to open RDP firewall port(s), 0 to close
        $NLAEnable - Set to 1 to enable, 0 to disable
        Section 1: Remote Desktop Connections
        Section 2: NLA (Network Level Authentication)
        Section 3: Recreate the WMI object so we can read out the (hopefully changed) setting

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [Alias('HostName')]
        [ValidateNotNullorEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $EnableRDP = Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\‘ -Name “fDenyTSConnections” -Value 0 -Force:$Force
            $NLA = Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\‘ -Name “UserAuthentication” -Value 1 -Force:$Force
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
                Status            = 'Unsucessful'
                ComputerName      = $ComputerName
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
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