#Enable RDP With NLA
# $RDPEnable - Set to 1 to enable remote desktop connections, 0 to disable
# $RDPFirewallOpen - Set to 1 to open RDP firewall port(s), 0 to close
# $NLAEnable - Set to 1 to enable, 0 to disable

# Remote Desktop Connections
$ComputerName = "Localhost"
$RDP = Get-WmiObject -Class Win32_TerminalServiceSetting -ComputerName $ComputerName -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy
$Result = $RDP.SetAllowTSConnections(1, 1) # First value enables remote connections, second opens firewall port(s)
if ($Result.ReturnValue -eq 0) {
    Write-Host "Remote Connection settings changed sucessfully"
}
else {
    Write-Host ("Failed to change Remote Connections setting(s), return code " + $Result.ReturnValue) -ForegroundColor Red
}

# NLA (Network Level Authentication)
$NLA = Get-WmiObject -Class Win32_TSGeneralSetting -ComputerName $ComputerName -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy
$NLA.SetUserAuthenticationRequired(1) | Out-Null 
# Does not set ReturnValue to 0 when it succeeds and we don't want to see screen output to pipe to null
# Recreate the WMI object so we can read out the (hopefully changed) setting
$NLA = Get-WmiObject -Class Win32_TSGeneralSetting -ComputerName $ComputerName -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy
if ($NLA.UserAuthenticationRequired -eq 1) {
    Write-Host "NLA setting changed sucessfully"
}
else {
    Write-Host "Failed to change NLA setting" -ForegroundColor Red
}