#Disable Automatic Proxy Detect
$RegKey = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
$Settings = (Get-ItemProperty -Path $RegKey).DefaultConnectionSettings
$Settings[8] = 1
Set-ItemProperty -path $regKey -name DefaultConnectionSettings -value $Settings
if ($Settings[8] -eq 1) {
    Write-Host "Proxy settings changed sucessfully"
}
else {
    Write-Host ("Failed to change Proxy setting(s)") -ForegroundColor Red
}