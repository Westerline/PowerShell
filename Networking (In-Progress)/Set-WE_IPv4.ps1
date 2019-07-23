<#
Requires Runas Administrator
Requires NIC connected
Code modified from: http://powershelldistrict.com/set-ip-address-using-powershell/
.TO Do
    Add DHCP Option
    Add Support for IPv6
#>

Function Replace-WE_NetIpAddress {

    [cmdletbinding()]
    Param(
        [Alias('AdapterName')]
        [String] $InterfaceAlias,
        [IPAddress] $IPAddress,
        [int] $Prefix,
        [IPAddress] $DefaultGateway,
        [IPAddress] $PrimaryDNS,
        [IPAddress] $SecondaryDNS
    )

    Begin {

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
            Write-Verbose "Couldn't configure IP settings for $InterfaceAlias."
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

    End { }

}
}
}