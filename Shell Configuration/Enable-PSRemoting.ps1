Start-Transcript -Path "C:\test.txt"

#Step 1: Local Account Token
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

#Step 2: Enable-PSRemoting
Enable-PsRemoting -Force

<#Step 3: Enable Legacy HTTP Listener on Port 80 (Optional)

Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -value True -Force

#>

Stop-Transcript

Exit