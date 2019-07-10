<#
Requires Runas Administrator
Requires NIC connected
Code modified from: http://powershelldistrict.com/set-ip-address-using-powershell/
To-do, add static vs dhcp options
#>

Function Replace-WE_NetIpAddress {

    [cmdletbinding()]
    Param(
        [String] $AdapterName,
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
           
            $Adapter = Get-NetAdapter -Name $AdapterName

            $InterfaceAlias = $AdapterName.InterfaceAlias
            
            $IPConfig = Get-NetIPConfiguration -InterfaceAlias $InterfaceAlias
            
            $DisableDHCP = Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceAlias $InterfaceAlias).InterfaceGuid)” -Name EnableDHCP -Value 0
            
            $OldGateway = $IPConfig.IPv4DefaultGateway.NextHop
            
            $Remove = Remove-NetRoute -InterfaceAlias $InterfaceAlias -NExtHop $OldGateway -Confirm:$False
            
            $Remove = Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -Confirm:$False
            
            $IPNew = New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $Prefix -DefaultGateway $DefaultGateway

            $DNS = Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $PrimaryDNS, $SecondaryDNS

            $Property = @{ 
                InterfaceAlias = $IPNew.InterfaceAlias  
                NewIPaddress   = $IPNew.IPaddress
                DefaultGateway = $IPNew.DefaultGateway
            }


        }

        Catch { }

        Finally { }

    }

    End { }

}
}
}