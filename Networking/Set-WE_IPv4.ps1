<#
Requires Runas Administrator
Requires NIC connected
Code modified from: http://powershelldistrict.com/set-ip-address-using-powershell/
.TO Do
    Add DHCP Option
    Add Support for IPv6
#>

Function Set-WE_IPv4 {

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

            $DisableDHCP = Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceAlias $InterfaceAlias).InterfaceGuid)” -Name EnableDHCP -Value 0

            $OldGateway = (Get-NetIPConfiguration -InterfaceAlias $InterfaceAlias).IPv4DefaultGateway.NextHop

            $RemoveNetRoute = Remove-NetRoute -InterfaceAlias $InterfaceAlias -NExtHop $OldGateway -Confirm:$False

            $RemoveIPAddress = Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -Confirm:$False

            $NewIPAddress = New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $Prefix -DefaultGateway $DefaultGateway

            $DNS = Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $PrimaryDNS, $SecondaryDNS

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
                InterfaceAlias = 'Null'
                IPaddress      = 'Null'
                Prefix         = 'Null'
                DefaultGateway = 'Null'
                DNS            = 'Null'
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