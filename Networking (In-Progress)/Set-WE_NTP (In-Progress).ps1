Param (
    [String] $AdapterName,
    $Computers = "",
    $NTP_PeerList = "0.nz.pool.ntp.org 1.nz.pool.ntp.org 2.nz.pool.ntp.org 3.nz.pool.ntp.org",
    $PrimaryDNS = "",
    $SecondaryDNS = ""
)

Begin { }

Process {

    Try {       

        $Adapter = Get-NetAdapter -Name $AdapterName

        $InterfaceAlias = $Adapter.InterfaceAlias
    
        $DNS = Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $PrimaryDNS, $SecondaryDNS

        Set-Service -Name W32Time -StartupType Automatic

        Start-Service -Name W32Time

        & w32tm /config /syncfromflags:manual /manualpeerlist:$NTP_PeerList /update

        & w32tm /resync /rediscover

        Get-Date

    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }

}

End { }