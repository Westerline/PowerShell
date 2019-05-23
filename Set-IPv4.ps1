Start-Transcript -Path 'C:\temp\Set-IPv4.txt'  -Append -Force


Try {

    #Define Variables
	
	$IPv4_Address = ""
	
	$Subnet = ""
	
	$Default_Gateway = ""
	
	$Primary_DNS = ""
	
	$Secondary_DNS = ""


    #Set IPv4 details for local net adapter

    If ($EthernetAdapter) {

        netsh.exe int ip set address $EthernetAdapter.InterfaceIndex static $IPv4_Address $Subnet $Default_Gateway 1

        netsh.exe int ip set dnsservers $EthernetAdapter.InterfaceIndex static $Primary_DNS primary

        netsh.exe int ip add dnsservers $EthernetAdapter.InterfaceIndex Index=2 $Secondary_DNS

        Write-Verbose 'The IP address settings were applied successfully.' -Verbose

    }



}



Catch {

    Write-Warning 'The IP address settings were not applied successfully.'

}


Stop-Transcript | Out-Null