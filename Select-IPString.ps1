#Lists IP Address for network adapters, can be passed as an object. Set the host portion to be variable depending on what the subnet mask is.

$IPAddress = @(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*")[0]
$HostPortion = $IPAddress.Substring(,)
