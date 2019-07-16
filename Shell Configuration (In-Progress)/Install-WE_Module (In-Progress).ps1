Param (
    [String] $Path,
    [String] $Scope
)

$Env:PSModulePath += "C:\Temp;"
Add-Content -Path $Profile.Scope -Value '$Env:MSModulePath += ";C:\Temp"'


New-Item "$($profile | split-path)\Modules\AudioDeviceCmdlets" -Type directory -Force
Copy-Item "C:\temp\AudioDeviceCmdlets.dll" "$($profile | split-path)\Modules\AudioDeviceCmdlets\AudioDeviceCmdlets.dll"
Set-Location "$($profile | Split-Path)\Modules\AudioDeviceCmdlets"
Get-ChildItem | Unblock-File
Import-Module AudioDeviceCmdlets