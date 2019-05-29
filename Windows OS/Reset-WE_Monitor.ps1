#This script is used to reset the dual monitor configuration for Windows. Add a backup function for the registry keys.

$Value1 = HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration
$Value2 = HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity

If ($Value1 -eq $False) {Remove-ItemProperty -path $Value1}
Else {Write-Output "$Value1 does not exist"}

If ($Value1 -eq $False) {Remove-ItemProperty -path $Value2}
Else {Write-Output "$Value2 does not exist"}