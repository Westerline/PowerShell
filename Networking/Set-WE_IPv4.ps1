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
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $IPAddress,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Prefix,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $DefaultGateway,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $PrimaryDNS,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $SecondaryDNS

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $DisableDHCP = Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceAlias $InterfaceAlias).InterfaceGuid)” -Name EnableDHCP -Value 0
            $OldGateway = (Get-NetIPConfiguration -InterfaceAlias $InterfaceAlias).IPv4DefaultGateway.NextHop
            $RemoveNetRoute = Remove-NetRoute -InterfaceAlias $InterfaceAlias -NExtHop $OldGateway -Confirm:$False
            $RemoveIPAddress = Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -Confirm:$False
            $NewIPAddress = New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $Prefix -DefaultGateway $DefaultGateway
            $DNS = Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $PrimaryDNS, $SecondaryDNS
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                InterfaceAlias = $NewIPAddress.InterfaceAlias
                IPaddress      = $NewIPAddress.IPaddress
                Prefix         = $NewIPAddress.Prefix
                DefaultGateway = $NewIPAddress.DefaultGateway
                DNS            = $DNS.ServerAddresses
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