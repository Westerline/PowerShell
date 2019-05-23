#1: Load Target Machines

$Computers = ""

$NTP_PeerList = "0.nz.pool.ntp.org 1.nz.pool.ntp.org 2.nz.pool.ntp.org 3.nz.pool.ntp.org" 

$PrimaryDNS = ""

$SecondaryDNS = ""

Foreach ($Computer in $Computers) {

    Write-Output "
    "
    Write-Output "----------------------------"
    
    Write-Output "Running NTP commands on $Computer"

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

    Write-Output "----------------------------"
    
    Write-Output "
    "

}