Param (
    [String] $Name
)

$app = Get-WmiObject -Class Win32_Product -Filter "Select * from Win32_Product WHERE Name = '$Name'"
$app.Uninstall()

<#
$uninstall32 = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "SOFTWARE NAME" } | select UninstallString
$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "SOFTWARE NAME" } | select UninstallString
if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /qb" -Wait}
if ($uninstall32) {
$uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall32 = $uninstall32.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall32 /qb" -Wait}
#>