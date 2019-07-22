Param (
    $PSCommandPath
)

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process Powershell.exe "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs
}