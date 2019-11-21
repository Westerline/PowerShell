Function Set-WE_IPv4 {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

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
            -Modified from: http://powershelldistrict.com/set-ip-address-using-powershell/
        To Do:
            -Add DHCP Option
            -Add Support for IPv6
        Misc:
            -Best if used while NIC connected, but may work with disconnected interfaces.
            -Requires Runas Administrator

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    #Requires -RunAsAdministrator

    [cmdletbinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('AdapterName')]
        [String]
        $InterfaceAlias,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $IPAddress,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 2)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Prefix,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 3)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $DefaultGateway,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 4)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $PrimaryDNS,

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $SecondaryDNS,

        [Parameter(Mandatory = $False,
        ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('IPv4','IPv6')]
        [String[]]
        $AddressFamily = 'IPv4',

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
            Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceAlias $InterfaceAlias).InterfaceGuid)” -Name EnableDHCP -Value 0 -Force:$Force
            $OldGateway = (Get-NetIPConfiguration -InterfaceAlias $InterfaceAlias).IPv4DefaultGateway.NextHop
            Remove-NetRoute -InterfaceAlias $InterfaceAlias -NextHop $OldGateway -Confirm:$False
            Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -Confirm:$False
            $SetIPAddress = New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $Prefix -DefaultGateway $DefaultGateway -AddressFamily $AddressFamily
            Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $PrimaryDNS, $SecondaryDNS
            $NetIPConfiguration = Get-NetIPConfiguration -InterfaceAlias $InterfaceAlias
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                InterfaceAlias = $NetIPConfiguration.InterfaceAlias
                IPAddress      = $NetIPConfiguration.IPv4Address.IPAddress
                Prefix         = $NetIPConfiguration.IPv4Address.PrefixLength
                DefaultGateway = $NetIPConfiguration.IPv4DefaultGateway.NextHop
                PrimaryDNS            = $NetIPConfiguration.DNSServer.ServerAddresses[0]
                SecondaryDNS            = $NetIPConfiguration.DNSServer.ServerAddresses[1]
            }

        }

        Catch {

            Write-Verbose "Unable to configure IP settings for $InterfaceAlias."
            $Property = @{
                Status            = 'Unsuccessful'
                InterfaceAlias    = $InterfaceAlias
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