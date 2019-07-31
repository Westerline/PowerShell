<#

#Chapters 1-8

#1
Get-EventLog -LogName Security -Newest 100

#2
Get-Process | Sort-Object -Property VM -Descending | Select-Object -First 5

#3
Get-Service | Select-Object -Property Name, Status | Sort-Object -Property Status -Descending | Export-Csv "$Env:HOMEDRIVE\temp\test3.csv" -NoTypeInformation

#4
Set-Service -Name BITS -StartupType Automatic

#5
Get-ChildItem -Path C:\ -Recurse -File -Include 'win*.*'

#6
Get-ChildItem -Path 'C:\Program Files' -Recurse | Out-File "$Env:HOMEDRIVE\temp\test6.txt"

#7
Get-EventLog -LogName Security -Newest 20 | ConvertTo-Xml | Format-Custom

#8
Get-EventLog -LogName * | Select-Object -Property LogDisplayName, MaximumKilobytes, OverflowAction | ConvertTo-Csv -NoTypeInformation

#9
Get-Service | Select-Object -Property Name, DisplayName, Status | ConvertTo-Html -Title "Service Report" -PreContent "<H1> Installed Services </H1>" | Out-File "$Env:HOMEDRIVE\temp\test9.html"

#10
New-Alias -Name D -Value Get-ChildItem -PassThru | Export-Alias "$Env:HOMEDRIVE\temp\test10.txt"
Import-Alias -Path "$Env:HOMEDRIVE\temp\test10.txt"

#11
Get-HotFix -Description 'Hotfix', 'Update'

#12
Get-Location

#13
Get-History -Id X | Invoke-History

#14
Limit-EventLog -LogName Security -OverwriteAction OverWriteAsNeeded

#15
New-Item -ItemType Directory -Path 'C:\' -Name 'Review'

#16
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'

#17
Restart-Computer
Stop-Computer
Remove-Computer
Restore-Computer

#18
Set-ItemProperty

#Chapters 1-14

#1
Get-Process | Format-Table -AutoSize -Property Id, Name

#2
Get-WmiObject -Class win32_systemdriver | Select-Object -Property Name, DisplayName, @{Label = 'Path'; Expression = { $_.PathName } }, StartMode, State | Format-List

#3
Invoke-Command -ComputerName LocalHost, Localhost -ScriptBlock { Get-PSProvider }

#4
$Content = 'LocalHost', 'LocalHost'
Set-Content -Value $Content -Path C:\temp\Computers.txt
Get-Serivce -ComputerName (Get-Content C:\temp\Computers.txt)

#5
Get-WmiObject -Class Win32_LogicalDisk -Filter "Drivetype = 3" | Select-Object -Property DeviceID, Size, FreeSpace, @{Label = 'PercentFreeSpace'; Expression = { ($_.FreeSpace / $_.Size).ToString("P") } } | Where-Object { $_.PercentFreeSpace -gt '50' }

#6
Get-CimClass -Namespace root\CIMv2 -ClassName Win32*

#7
Get-WmiObject -Class Win32_Service -Filter "StartMode = 'Auto' AND State <> 'Running'"

#8
Send-MailMessage -From Test1 -Subject Required -To Test2

#9
Get-ACL -Path C:\ | Format-List

#10
Get-ChildItem C:\users | Get-ACL | Format-List
Get-ChildItem C:\Users -Directory -Hidden | Get-ACL | Format-List

#11
$Credential = Get-Credential
Start-Process -Credential $Credential -FilePath C:\windows\notepad.exe

#12
Start-Sleep -Seconds 10

#13
help about_operators

#14
Get-WinEvent -ListLog * | Where-Object { $_.RecordCount -gt '0' } | Sort-Object -Property RecordCount -Descending

#15
Get-CimInstance -ClassName Win32_Processor | Select-Object -Property NumberOfCores, Manufacturer, Name, @{Label = "MaxSpeed"; Expression = { $_.MaxClockSpeed } } | Format-Table -AutoSize

#16
Get-CimInstance -ClassName Win32_Process -Filter "PeakWorkingSetSize >= 100000" | Select-Object -Property Name, Path, PeakPageFileUsage, PeakVirtualSize, PeakWorkingSetSize | Format-Table -AutoSize

#17
Find-Module -Tag Network | Sort-Object -Property Name | Select-Object -Property Name, Version, Description



#Chapters 1-19

1. Start-Job
2. Invoke-Command -AsJob
3. Yes, legal variable name
4. Get-Variable -Scope Local
5. Read-Host
6. Write-Output

#1
Get-Process | Select-Object -Property Name, Id, @{Label = 'VM (MB)'; Expression = { [Math]::Round($_.VM / 1MB, 2) } }, @{Label = 'PM (MB)'; Expression = { [Math]::Round($_.PM / 1MB, 2) } } | ConvertTo-Html -Title "Current Processes" | Out-File -FilePath "C:\temp\Current Process.html"

#2
Get-CimInstance -ClassName Win32_Service | Select-Object -Property Name, State, StartMode, StartName | Export-Csv -Path C:\Temp\Services.tdf -Delimiter "`t"

#3
[string] $Computer = Read-Host -Prompt "Please enter a computername."
Get-CimInstance -ComputerName $Computer -ClassName WIn32_OperatingSystem | Select-Object -Property CSName, Caption, Version, LastBootUpTime, @{Label = 'Uptime'; Expression = { (Get-Date) - $_.LastBootUpTime } }

#5
$Job = Start-Job -ScriptBlock { Get-WmiObject -Class Win32_Product }
Wait-Job -Id $Job.Id
Write-Output "Job's done!"
Receive-Job -Id $Job.Id -Keep | Select-Object -Property Name, Vendor, InstallDate, InstallLocation | Out-GridView -Title "My Products"

#>