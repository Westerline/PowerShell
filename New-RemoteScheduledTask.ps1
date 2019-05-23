<#
Example script to show how to run a process in the same sesssion as a remote user via Task Scheduler. Translate to PowerShell
#>

$Sessions = New-PSSession -ComputerName (Get-Content C:\test.txt)

        Invoke-Command -Session $Sessions -ScriptBlock {
            
            Write-Output "","________________________________"
    
            $StartTime = (get-date).AddMinutes(1).ToString("HH:mm")

            $StartDate = Get-Date -UFormat "%d/%m/%Y"

            Write-Output "Creating scheduled task for test.exe on $Env:Computername @ $StartTime $StartDate"

            schtasks /create /tn "Start Test.exe" /tr c:\temp\test.exe /sc once /st $StartTime /sd $StartDate /ru test /rp test

            Write-Output "________________________________",""

        }