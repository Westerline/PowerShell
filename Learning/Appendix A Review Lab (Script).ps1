<#
.SYNOPSIS
    This script is the answer for PowerShell in a Month of Lunches, Appendix A, Chapters 1-19, Task 4.

.DESCRIPTION
    This is a more detailed description of the script.

.PARAMETER UseExitCode
    This switch will cause the script to close after the error is logged if an error occurs. It is used to pass the error number back to the task scheduler.
    Aliases for the Computer Name parameter include 'hostname' and 'CN'.

.EXAMPLE
    Error handling.ps1

    Description
    ----------
    This would be the description for the example.

.NOTES
    Author: Wesley Esterline
    Updated:
        Added minimum amount for comment based help.
    Date Started:
#>
[CmdletBinding()]
Param (

    [Parameter(Mandatory = $True)]
    [Alias('hostname', 'CN')]
    [ValidateSet('Localhost', 'Computer1', 'Computer2')]
    [string]$ComputerName

)

Write-Output "","Getting Operating System information from $ComputerName..."

Get-CimInstance -ComputerName $ComputerName -ClassName WIn32_OperatingSystem | Select-Object -Property @{Label = 'ComputerName'; Expression = { $_.CSName } }, @{Label = 'OperatingSystemName'; Expression = { $_.Caption } }, Version, LastBootUpTime, @{Label = 'Uptime'; Expression = { (Get-Date) - $_.LastBootUpTime } }

Write-Output "","Operating System information retrieved successfully."